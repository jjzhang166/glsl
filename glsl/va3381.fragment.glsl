/* Lots of meteors by Kabuto  */
 
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float scale = 1.534212;
const mat3 dottransform = mat3(
0.11651722197701599,0.3544947103881083,0.9277700347012776,
-0.10673931989767256,-0.9242528744643419,0.3665560552387368,
0.9874363040574016,-0.14173963578072568,-0.06985285304270773
)*scale;

float meteor(vec3 pos)
{
	vec3 position = pos;
	float height = 0.0;
	float negheight = 0.0;
	float f = .1;
	position *= f;
	for (int i = 0; i < 15; i++) {
		vec3 v = fract(position)-.5;
		vec3 signv = sign(fract(position*.5)-.5);
		float signf = signv.x*signv.y*signv.z;
		float dots = max(0.,.15-dot(v,v));
		dots = dots*dots*dots/f;
		height += max(0.,dots*signf)*abs(dots);
		negheight += min(0.,dots*signf)*abs(dots);
		f *= scale;
		position *= dottransform;
	}
	
	
	return (sqrt(height)-sqrt(-negheight))*55.1+.5;
}
	
float n1,n2,n3,n4;
vec2 size = vec2(-0.4,0.0);
const float maxdist = 100.;
void main( void ) {
	float x = (mouse.x-.5)*6.;
	float y = (mouse.y-.5)*3.;
	mat3 viewmat = mat3(1,0,0,0,cos(y),sin(y),0,-sin(y),cos(y)) * mat3(cos(x),0, sin(x),0,1,0,-sin(x),0,cos(x));
	
	vec3 pos = vec3(0,0,time);
	vec3 dir = normalize(vec3((gl_FragCoord.xy-resolution.xy*0.5)/resolution.x,.5))*viewmat;
	
	// raymarch
	float dist = 0.;
	for (int i = 0; i < 200; i++) {
		float h = meteor(pos);
		pos += dir*h*.8;
		dist += h;
		if (h < .0001 || dist > maxdist) break;
	}
	
	// compute surface normal
	float h = meteor(pos);
	float d = .01;
	vec3 hd = (vec3(meteor(pos+vec3(d,0,0)),meteor(pos+vec3(0,d,0)),meteor(pos+vec3(0,0,d)))-h)/d;
	float c = (dot(vec3(1,0,0),normalize(vec3(hd)))+1.)*.5;
	
	dist = max(0.,1.-dist/maxdist);
	gl_FragColor = vec4(max(0.,1.-h)*dist*dist*dist*vec3(pow(c,1.7),pow(c,1.5),pow(c,1.)),1.);
}