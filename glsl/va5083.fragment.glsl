#ifdef GL_ES
precision highp float;
#endif
uniform sampler2D tex;
uniform float time;
uniform vec2 resolution;


const float fade = 1.;
float aspectRatio;

const float PI=3.14159;

float checker(vec2 p)
{
	return mod(floor(p.x)+floor(p.y), 2.);
}

vec4 getTexture(vec2 p) {
	float t = time;
	vec4 color = vec4(0.,0.,0., 0.);
	
	float a0 = (fract(0.+ p.x * .2) < .3)?0.:1.;
	float b0 = (fract(t + p.y * .1) < .7)?0.:1.;
	
	float a1 = (fract(.2 + p.x * .7) < .13)?0.:1.;
	float b1 = (fract( t -  p.y * .2) < .25)?0.:1.;
	
	color = (a1*b1) + a0*b0 * vec4(1,0,1, 1);
	
	return color * .5;
}
vec3 tunnel_uvw(vec2 pos);
vec3 tunnel_coord(vec2 p, float frekv, float radius, vec3 eltolas, vec3 nezet, vec3 irany);
void main(void) {
	vec2 position = ( gl_FragCoord.xy / resolution.y);
	aspectRatio = ( resolution.x / resolution.y); 
	
	//float ttime = time;
	float ttime = 0.;
	
	vec3 tunnel_pos = tunnel_coord(position-vec2(aspectRatio*.5,.5), 5., .125, vec3(-5.*ttime, sin(2.*ttime), cos(2.*ttime)), vec3(1., 0., 0.), vec3(0.,cos(cos(ttime)),sin(sin(ttime))));
	tunnel_pos += time;
	//gl_FragColor.rgb = (1.+.05*tunnel_pos.z) * fade*(vec3(.0,.1,.1) + checker(tunnel_pos.xy) * vec3(.6,.6,.7));
	gl_FragColor.rgb =  (1.+.05*tunnel_pos.z) * getTexture(tunnel_pos.xy).rgb;
	gl_FragColor.a = 1.0;
}
vec3 tunnel_uvw(vec2 pos){float u = length(pos);return vec3 (u, atan(pos.y, pos.x), 1.0/u);}
vec3 tunnel_coord(vec2 p, float frekv, float radius, vec3 eltolas, vec3 nezet, vec3 irany){vec3 cp=eltolas, ct=cp+nezet, 	cd=normalize(ct-cp), cr=normalize(cross(cd,irany)), cu=cross(cr,cd), rd=normalize(radius*cd+cr*p.x+cu*p.y), o = cp, d = rd;float D=1./(d.y*d.y+d.z*d.z), a=(o.y*d.y+o.z*d.z)*D, b=(o.y*o.y+o.z*o.z-36.)*D, t=-a-sqrt(a*a-b);o+=t*d;return vec3(o.x, atan(o.y,o.z)*(frekv/PI), t);}
