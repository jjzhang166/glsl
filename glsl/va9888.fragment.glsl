#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pi = atan(1.)*4.;

vec3 rotate(vec3 v,vec3 r) 
{
	mat3 rxmat = mat3(1,   0    ,    0    ,
			  0,cos(r.y),-sin(r.y),
			  0,sin(r.y), cos(r.y));
	mat3 rymat = mat3(cos(r.x), 0,-sin(r.x),
			     0    , 1,    0    ,
			  sin(r.x), 0,cos(r.x));
	mat3 rzmat = mat3(cos(r.z),-sin(r.z),0,
			  sin(r.z), cos(r.z),0,
			     0    ,   0     ,1);
	
	return v*rxmat*rymat*rzmat;
	
}

vec3 scene(vec3 v)
{
	//Top plane and bottom plane
	float tp = dot(v,vec3(0,-1,0));
	float bt = dot(v,vec3(0,1,0));
	
	return v/min(tp,bt);
}

vec3 tex(vec2 position)
{
	// from http://glsl.heroku.com/e#8558.0
	float sum = 0.;
	float qsum = 0.;
	
	for (float i = 0.; i < 5.; i++) {
		float x2 = i*i*.3165+(250.*i*0.01)+.5;
		float y2 = i*.161235+(250.*i*0.01)+.5;
		vec2 p = (fract(position-vec2(x2,y2))-vec2(.5));
		float a = atan(p.y,p.x);
		float r = length(p)*200.;
		float e = exp(-r*.8);
		sum += sin(r+a+time)*e;
		qsum += e;
	}
	
	float color = sum/qsum;
	return step( 0.25, vec3( color, color-.5, -color ) );
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy )*2.0-1.0;
	
	vec2 sp = mouse-0.5;
	
	vec2 move = vec2(0.2,0.6);

	vec3 uvw = scene(rotate(vec3(p,1.2), vec3(sp.x,sp.y,sin(time*0.5))));
	
	uvw.xz -= time*move;
	vec3 cam = vec3(0);
	cam.xz  -= time*move;
	
	vec3 color = tex(uvw.xz*.1);
	color *= 1.-distance(uvw,cam)*0.1;
	
	gl_FragColor = vec4(color, 1.0 );

}