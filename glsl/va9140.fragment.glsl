#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


#define PI 3.14159
#define RGB(r,g,b) vec3(r/255.,g/255.,b/255.)

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

vec3 normal(vec2 a)//normal from yaw/pitch
{
	return vec3(sin(a.x)*cos(a.y), sin(a.y), -cos(a.x)*cos(a.y));
}

vec2 angle(vec3 n) //yaw/pitch from normal
{
	return vec2(atan(n.z/n.x),atan(n.y/length(n.xz)));
}

vec3 tex(vec2 p)
{
	return vec3(abs(max(sin(p.y*PI*16.),sin(p.x*PI*16.))))*.5+.5;
}

float noise(vec3 p) //by. Las^Mercury
{
	vec3 i = floor(p);
	vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
	vec3 f = cos((p-i)*acos(-1.))*(-.5)+.5;
	a = mix(sin(cos(a)*a),sin(cos(1.+a)*(1.+a)), f.x);
	a.xy = mix(a.xz, a.yw, f.y);
	return length(a);

}

vec3 crater(float r, float x, float y,vec2 ang) {
    	float z = sqrt(r*r - x*x - y*y) * 1.5;

    	vec3 normal = normalize(vec3(x, y, z));
	
	normal = rotate(normal,ang);
	
	if(length(vec2(x,y)) > r)
	{
		return vec3(0,0,-1);	
	}
	
	return normal;
}

void main( void ) {
	vec2 center = resolution / 2.;
	vec2 pos = gl_FragCoord.xy - center;
	float asp = resolution.y;

	vec2 ang = (mouse*2.-1.)*PI*vec2(2.,1.);
	
	vec3 color = vec3(0.);

	
	vec3 n = crater(0.35*asp,pos.x, pos.y,ang);
	
	
	vec3 shade = vec3(dot(n,vec3(0,0.5,0.5)));
	shade = max(shade,vec3(dot(n,vec3(0,-0.5,-0.5))));
	
	color = tex(angle(n)/vec2(PI));
	
	color *= (mix(RGB(106.,88.,135.),RGB(241.,220.,150.),shade.r)*shade);
	
	
	gl_FragColor = vec4(color, 1.0);
}