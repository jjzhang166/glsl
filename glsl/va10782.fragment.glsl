#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D backbuffer;

mat2 rot90m = mat2( vec2(0, -1), vec2(1, 0));

float generateHeight(vec2 pos){
	//return sin(length(pos-vec2(0.5,0.5))*100.0+time*4.0)*sin(length(pos-vec2(0.0,0.5))*100.0+time*4.0);
	//return sin(pos.x*100.0)+sin(pos.y*100.0);
	//return 1.0;
	float r = sin(pos.x*pos.y*100.*cos(pos.x*77.77)*time)*cos(tan(log(pos.x)+pos.y/time))/fract(tan(pos.x*pos.x*pos.y)*(time)*100.);
	return sin(r+time);
}

vec3 generateNormal(vec2 pos){
	float x = pos.x;
	float y = pos.y;
	
	vec3 lH = vec3( 1.0, 0.0, generateHeight(pos + vec2(1.0/resolution.x,0.0) ) );
	vec3 uH = vec3( 0.0, 1.0, generateHeight(pos + vec2(0.0,1.0/resolution.y) ) );
	//vec3 rH = vec3( -1.0, 0.0, generateHeight(pos + vec2(-1.0,0.0) ) );
	//vec3 dH = vec3( 0.0, -1.0, generateHeight(pos + vec2(0.0,-1.0) ) );
	vec3 H = vec3( 0.0, 0.0, generateHeight(pos));
	
	vec3 normal = cross( lH - H, uH - H);
	
	//vec3 normal = uH-H;
	return normalize(normal);
}

vec4 rect1x1(vec2 v)
{
  if(-0.5<=v.x && v.x<=0.5 && -0.5<=v.y && v.y<=0.5){
	  return(vec4(1.0,1.0,0.0,1.0));
  }else{
	  return(vec4(0.0,0.0,0.0,0.0));
  }
}

vec2 o2n(vec2 v)
{
	return vec2(
		(v.x*2.0-resolution.x)/resolution.y,
		(v.y*2.0-resolution.y)/resolution.y
		);
}

vec2 n2o(vec2 v)
{
	return vec2(
		(v.x*resolution.y+resolution.x)*0.5,
		(v.y*resolution.y+resolution.y)*0.5
		);
}

vec4 neg(vec4 v)
{
	return vec4(1.0-v.r,1.0-v.g,1.0-v.b,v.a);
}


vec4 paint(vec4 b,vec4 f)
{
	if(b.a==0.0){
		return(b);
	}else if(f.a==0.0){
		return(b);	
	}else{
		return(f);
	}
}

vec2 rot90(vec2 v)
{
   return vec2( v.y,-v.x);	
}

void main( void )
{
	vec2 coords = vec2( gl_FragCoord.xy / resolution.xy );
	
	vec3 position = vec3(coords, 0.0);

	float color = 0.0;
	
	vec3 mouse = vec3(1./mouse * 32., 0.1);
	
	//cut an arc across the stuff at http://glsl.heroku.com/e#10740.27 
	float noise = generateHeight(coords*mouse.x);
	
	vec2 npos=o2n(noise*3.*gl_FragCoord.xy);
	vec2 npos2=rot90(npos)*1.5+0.25;

	vec2 opos=n2o(npos2);
	vec2 texPos = vec2(opos/resolution);
	vec4 zenkai = texture2D(backbuffer, texPos);
	vec4 hanten = neg(zenkai);

	gl_FragColor = paint(rect1x1(npos),hanten);
}
