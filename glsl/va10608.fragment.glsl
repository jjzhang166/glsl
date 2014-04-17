#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float line(vec2 p, float k, float d);            
float circle(vec2 p, vec2 t, float r);
float hash(vec2 co);
float noise(vec2 p, float s);
float mix2(float a2, float b2, float t2);
float fractnoise(vec2 p, float s, float c);
vec2 blockMod(vec2 uv, float modulus);

#define eps 0.05

void fractnoiseGradient(vec2 p, float s, float c, out float sd, out vec2 n)
{
	vec2 px = vec2(p.x + eps, p.y);	
	vec2 py = vec2(p.x, p.y + eps);
	
	sd = fractnoise(p, s, c);
	float sdx = fractnoise(px, s, c);
	float sdy = fractnoise(py, s, c);

	n = (vec2(sd, sd) - vec2(sdx, sdy))/eps;
}



void main() 
{
	vec2 p = (gl_FragCoord.xy / resolution.x) * 2.0 - vec2(1.0, resolution.y / resolution.x);
	vec2 m = (mouse) * 2.0 - vec2(1.0, resolution.y / resolution.x);
	p.y += sin((p.x * .4) * time*.3)*.5;
	p.x += time/5.0;

	
	float sd;
	vec2 n;
	fractnoiseGradient(p, .0009, 2.5, sd, n);
	
	float sdl = clamp(smoothstep(.09, .07, p.y+sd), 0., 1.);
	float sdf = .2+clamp(smoothstep(.9, .7, sdl+sd), 0., 1.);
	
	n = .5+normalize(n)*.5;
	
	
	vec2 lp = vec2(m.x+time/5., m.y);
	vec2 ld = normalize(lp-p);
	float ndl = dot(n, ld);


	vec2 h = normalize(lp-vec2(.5));

	float df = max(0.0, dot(vec2(.5), ld));
   	float sf = max(0.0, dot(vec2(.45), h));
	
	sdl*=.5;
	
	vec4 colors = .3*(p.y-sd-.02)+vec4(.15, .34, .924, 1.)*vec4(.25*sdf*(1.-p.y)) + vec4(sdl+sdl*ndl) * vec4(.87, .5, .24, 1.)* sdf + vec4(.2, .2, .3, .5)*df*sf;

	gl_FragColor = pow(colors, vec4(1.6)); //gamma
	
	//light isnt right, needs cleanup, but promising - s
}


float line(vec2 p, float k, float d)
{
	return p.y - k*p.x+d;
}
            
float circle(vec2 p, vec2 t, float r)
{
	return length(p-t) - r;
}

float hash(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float s){
	return fract(956.9*cos(429.9*dot(vec3(p,s),vec3(9.7,7.5,11.3))));
}
 
float mix2(float a2, float b2, float t2)
{
	return mix(a2,b2,t2*t2*(3.-2.*t2)); 
}
	
float fractnoise(vec2 p, float s, float c){
	float sum = .0;
	for(float i=0. ;i<6.; i+=1.){
        
		vec2 pi = vec2(pow(2.,i+c));
		vec2 posPi = p*pi;
		vec2 fp = fract(posPi);
		vec2 ip = floor(posPi);
	
		float n0 = noise(ip, s);
		float n1 = noise(ip+vec2(1.,.0), s);
		float n3 = noise(ip+vec2(.0,1.), s);
		float n4 = noise(ip+vec2(1.,1.), s);
		
		float m0 = mix2(n0,n1, fp.x);	
		float m1 = mix2(n3,n4, fp.x);
		float m3 = mix2(m0, m1, fp.y);
		
        	sum += 2.0*pow(.5,i+c)*m3;
	}
	
	return sum*(2.2-c);
}

vec2 blockMod(vec2 uv, float modulus){
	return vec2(uv.x - mod(uv.x, modulus/resolution.x), uv.y - mod(uv.y, modulus/resolution.y));;
}

//sphinx + rianflo