#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = 3.14159;

vec3 rotate(vec3 v,vec2 r) 
{
	mat3 rxmat = mat3(1,   0    ,    0    ,
			  0,cos(r.y),-sin(r.y),
			  0,sin(r.y), cos(r.y));
	mat3 rymat = mat3(cos(r.x), 0,-sin(r.x),
			     0    , 1,    0    ,
			  sin(r.x), 0,cos(r.x));
	
	
	return v*rxmat*rymat;
	
}

float snoise(vec3 v);

void main( void ) {

	vec2 res = vec2(resolution.x/resolution.y,1.0);
	vec2 p = ( gl_FragCoord.xy / resolution.y ) -(res/2.0);
	
	vec2 m = (mouse-0.5)*pi*vec2(2.,1.);
	
	vec3 color = vec3(0.0);
	
	vec3 pos = normalize(rotate(vec3(p,1.0),vec2(m)));
	
	float dist = 0.0;
	
	for(float i = 1.;i <= 8.;i++)
	{
		float shell = abs(snoise(pos*i+vec3(time,0,0)*0.13));
		
		shell = smoothstep(0.25,0.2,shell);
		
		dist = max(dist,shell*(1.-(i/8.)));
	}
	
	color = mix(vec3(0., 1.0, 0.0),vec3(.7,0.0,0.2),1.-dist);
		
	gl_FragColor = vec4(  color.xyz , 1.0 );

}



float snoise(vec3 v) {
	return (sin(v.x*8.)*cos(v.y*8.)-sin(v.z*8.));
}