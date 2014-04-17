#ifdef GL_ES
precision mediump float;
#endif
#define SIZE 3.7
#define SPEED .17

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.14159;

float rand(vec3 co){
    return 0.9+0.1*fract(sin(co.z+dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
    //return 1.;
}


vec3 rotate(vec3 v,vec2 r) 
{
	mat3 rxmat = mat3(1,   0    ,    0    ,
			  0,cos(r.y),-sin(r.y),
			  0,sin(r.y), cos(r.y));
	mat3 rymat = mat3(cos(r.x), 0,-sin(r.x),
			     0    , 1,    0    ,
			  sin(r.x), 0,cos(r.x));
	
	
	return (v*rxmat)*rymat;
	
}

vec3 norm(vec3 v)
{
	//box made of 6 planes
	float tp = dot(v,vec3(0,-1,0))*SIZE;
	float bt = dot(v,vec3(0,1,0))*SIZE;
	float lf = dot(v,vec3(1,0,0))*SIZE;
	float rt = dot(v,vec3(-1,0,0))*SIZE;
	float fr = dot(v,vec3(0,0,1))*SIZE;
	float bk = dot(v,vec3(0,0,-1))*SIZE;
	
	return v/min(min(min(min(min(tp,bt),lf),rt),fr),bk);
}

float grid(vec3 v)
{
	float g;
	
	g = (length(v));
	g = (1.0-(g*g)*1.97)*1.38*rand(v);
	return g*g-0.225;
}
void main( void ) {
	vec2 res = vec2(resolution.x/resolution.y,1.0);
	vec2 p = ( gl_FragCoord.xy / resolution.y ) -(res/2.0);
	
	vec2 m = vec2(cos(time*SPEED), sin(time*SPEED));
	
	vec3 color = vec3(0.0);
	
	vec3 pos = norm(rotate(vec3(p,0.5),vec2(m)));
	
	float c = grid(pos);
	color = vec3(c*.91, c*1., c*1.);
	//color = vec3(c*(0.5+0.5*pos.x),c*(0.5+0.5*pos.y),c*(0.5+0.5*pos.z));
	
	// Using http://glsl.heroku.com/e#9001.0
	vec3 vignette = vec3(sin(time)*.25, 0.0, 1.0);
	float l = sin(gl_FragCoord.y*abs(cos(sin(time*SPEED))*1.01+.1205)+time*SPEED);
	vignette += vec3(l*abs(cos(time*37.1*gl_FragCoord.y)), l*abs(cos(time*SPEED)), l*abs(cos(time*51.71)));
	
	vec3 final_c = mix(color, vignette, 0.04);
	
	gl_FragColor = vec4( final_c , 1.0 );
}