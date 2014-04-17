#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = atan(1.)*4.;

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

float round(float v)
{
	return floor(v+0.5);	
}

vec3 tunnel(vec3 p)
{
	return p/sqrt(p.x*p.x+p.y*p.y);
}

vec3 tex(vec2 p,vec3 pos,vec3 cam)
{	
	vec3 lpos = pos;
	lpos.z = mod(lpos.z*0.25,1.) ;
	
	float l = (1./distance(vec3(0,0.8,0.5),lpos)*0.6);
	
	float off = step(mod(p.x,1./32.)*32.,0.5)*0.125;
	
	vec2 mp = vec2(mod(p.x,1./64.)*64.,mod(p.y+off,1./4.)*4.);
	
	float bx = smoothstep(0.95,1.,mp.x)+smoothstep(0.05,0.0,mp.x);
	float by = smoothstep(0.95,1.,mp.y)+smoothstep(0.05,0.0,mp.y);
	vec3 brick = mix(vec3(0.1),vec3(0.3,0.15,0.1),1.-(bx+by));
	
	return mix(brick*l,vec3(0.1),clamp(distance(pos,cam)*0.05,0.,1.));
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy)-resolution/2.;
	
	vec2 cam_a = vec2(mouse.x*pi*2.,(mouse.y-.5)*pi);
	vec3 cam_p = vec3(0,0,-time);
	
	vec3 pos = tunnel(rotate(vec3(p,700.),cam_a));
	pos.z -= time;
	
	vec2 uv = vec2((atan(pos.x,pos.y)+pi)/(pi*2.),pos.z);
	
	vec3 fc = tex(uv,pos,cam_p);

	gl_FragColor = vec4( fc, 1.0 );

}