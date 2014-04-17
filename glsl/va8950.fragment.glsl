#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.1;


vec3 norm(vec3 v)
{
	return v/pow((pow(v.x,32.)+pow(v.y,32.)+pow(v.z,32.)),1./32.);
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

float average(vec3 v)
{
	return (v.x+v.y+v.z)/3.0;
}

void main( void ) {

	vec2 res = vec2(resolution.x/resolution.y,1.0);
	vec2 p = ( gl_FragCoord.xy / resolution.y ) -(res/2.0);
	
	vec2 m = (mouse-0.5)*pi*vec2(2.,1.);
	
	vec3 color = vec3(1.0);
	
	vec3 pos = norm(rotate(vec3(p,0.5),vec2(m)));
	
	color *= 1.-length(pos)*0.7;
	
	for(float a = 0.;a <= 360.;a+= 360./8.)
	{
		float ar = a*(pi/180.0)+time;
		color += vec3(1./sqrt(distance(vec3(cos(ar),sin(ar*2.0+time),sin(ar)),pos))*0.05);
	}
	
	color *= smoothstep(-1.0,-0.95,pos)*smoothstep(1.0,0.95,pos);
		
	gl_FragColor = vec4(  color , 1.0 );

}