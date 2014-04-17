#ifdef GL_ES
precision mediump float;
#endif

// by @rianflo + sphinx
//next todo:
//save positions and coefficients (f,a) for p[] (convert to pixel memory) (currently f,a are randomized every frame)
//sample points based on confidence (now being set to 1 as green channel)
//construct sample kernel for laplacian rather than single uv point summing (basically make f correct)
//gather full screen result
//cleanup

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define tpi 4./atan(1.)
#define tau 2.*tpi

float noise(vec2 p, float s);
vec3 fractnoise(vec2 p, float s);
float fractnoise(vec2 p, float s, float c);
float mix2(float a2, float b2, float t2);
float rand(vec2 v);

void main( void ) 
{
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 m = uv-mouse;
	float modulus = 1.;
	vec2 block = vec2(uv.x - mod(uv.x, modulus/resolution.x), uv.y - mod(uv.y, modulus/resolution.y));
		
	
	vec2 p[32]; // random fixed point (also, wtf glsl arrays?)
	p[0]  = vec2(-0.9801362166181207, 0.7133320029824972);
	p[1]  = vec2(0.6841536369174719, 0.0452396422624588);
	p[2]  = vec2(-0.1876563378609717, -0.2995676286518574);
	p[3]  = vec2(0.4626036649569869, 0.2069109776057303);
	p[4]  = vec2(0.5863597164861858, -0.47225348791107535);
	p[5]  = vec2(-0.2134767766110599, 0.5314431264996529);
	p[6]  = vec2(-0.40354382060468197, 0.6179361962713301);
	p[7]  = vec2(0.8017559270374477, 0.4957537869922817);
	p[8]  = vec2(-0.6258918326348066, -0.19205209147185087);
	p[9]  = vec2(-0.6484965835697949, 0.12037607934325933);
	p[10] = vec2(0.1817763289436698, -0.7319995686411858);
	p[11] = vec2(0.03400439955294132, 0.015528503805398941);
	p[12] = vec2(-0.8207575110718608, -0.20950394216924906);
	p[13] = vec2(0.4620666257105768, -0.8298074207268655);
	p[14] = vec2(0.7118636784143746, -0.18039523344486952);
	p[15] = vec2(0.7459373427554965, -0.9192065331153572);
	p[16] = vec2(-0.8379013403318822, -0.4257906102575362);
	p[17] = vec2(0.6868163528852165, -0.5935090645216405);
	p[18] = vec2(-0.7533727665431798, 0.34916585916653275);
	p[19] = vec2(0.5584901617839932, -0.17079990822821856);
	p[20] = vec2(-0.05607030261307955, -0.20109707489609718);
	p[21] = vec2(-0.5292902691289783, -0.3160477024503052);
	p[22] = vec2(0.958707966376096, 0.07811622228473425);
	p[23] = vec2(-0.9669322278350592, -0.7668777015060186);
	p[24] = vec2(-0.514001720584929, 0.21057891100645065);
	p[25] = vec2(0.625888504087925, 0.24024034570902586);
	p[26] = vec2(0.14085335237905383, -0.9223673334345222);
	p[27] = vec2(0.9979954264126718, 0.019927598536014557);
	p[28] = vec2(-0.6689602402038872, -0.18976282747462392);
	p[29] = vec2(-0.9763824176043272, -0.27004000497981906);
	p[30] = vec2(0.4638286428526044, -0.08488307567313313);
	p[31] = vec2(0.2535161036066711, -0.5959352040663362);
	
	float f;
	float a;
	float rf;
	for(int i = 0; i < 32; i++){
		float f = rand(p[i]*vec2(sin(float(i)) * time *  0.15)); 
		float a = rand(p[i]*vec2(sin(float(i)) * time * -0.31)) * .25;
		
		rf += cos(rf * length(block-p[i]) * f * tau) * a;
		
		rf *= step(.005,length(uv-p[i]));
	}
	
	rf = floor(rf*256.5)/256. * .5;
	
	//Signal (using simple noise function, could be anything, should be buffered instead of reevaluated)
	float noise = length(fractnoise(block + vec2(6.001, 5.0), 725., 1.4));
	noise = fract(.25*noise*modulus);	//block
	noise = floor(noise*256.5)/256.; 	//band
	float signal = noise;
	
	//Buffer
	vec4 buffer = texture2D(backbuffer, uv);	
	vec4 result = buffer;
	result.z = rf;
	
	//Match
	vec3 tolerance = vec3(.0);//05;
	if (buffer.a == 0.){
		result.a = 0.;

		if(rf == signal){
			result 	=  vec4(0., .5, 0., 1.);
			result.rgb += signal * .1;
		}
	}
	
	//Auto Reset
	float timer = fract(time * .05);
	if(time < 1. || timer < .001 || false){
		result = vec4(vec3(signal), 0.);
	}
	
	gl_FragColor = vec4(result);
	//gl_FragColor = vec4(rf);
	//gl_FragColor = vec4(signal);
	//not too shabby
}

float rand(vec2 v){ 
	return fract(sin(dot(v ,vec2(12.9898,78.233))) * 42308.5453); 
}

float noise(vec2 p, float s){
      return fract(956.9*cos(429.9*dot(vec3(p,s),vec3(9.7,7.5,11.3))));
}
 
float mix2(float a2, float b2, float t2)
{ return mix(a2,b2,t2*t2*(3.-2.*t2)); }
	
float fractnoise(vec2 p, float s, float c){
	float sum = .0;
	for(float i=0. ;i<6.; i+=1.){
        
	vec2 pi = vec2(pow(2.,i+c)), fp = fract(p*pi), ip = floor(p*pi);
        	sum += 2.0*pow(.5,i+c)*mix2(mix2(noise(ip, s),noise(ip+vec2(1.,.0), s), fp.x), mix2(noise(ip+vec2(.0,1.), s),noise(ip+vec2(1.,1.), s), fp.x), fp.y);
	}
	
      return sum*(2.2-c);
}
    
vec3 fractnoise(vec2 p, float s){
	vec3 sum = vec3(.0);
	for(float i = .0; i<4.; i+=1.)
	{
		sum += fract(vec3(99.9)*vec3(cos(12.9+s*29.8+i*19.9),cos(14.0+s*17.9+i*23.7),cos(12.1+s*22.1+i*24.5)))*vec3(fractnoise(p, s+i, (i+1.0)));
	}
	return sum;
}