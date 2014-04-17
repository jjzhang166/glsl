#ifdef GL_ES
precision mediump float;
#endif

// *** http://wzl.vg ***
//     trbl was here

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int maxseg = 200;
void main( void ) {

vec2 fc = gl_FragCoord.xy;
vec2 p = fc.xy/resolution.xy;
vec2 q = -1.0 + 2.0 * p;
q.x *= resolution.x / resolution.y;
 

	//Fisheye
vec2 mid = resolution / 2.0;
mid.y += sin(time) * resolution.x / 8.0;
mid.x += cos(time) * resolution.y / 8.0;
vec2 dir = fc - mid;
dir = normalize(dir);
fc -= -dir * smoothstep(.4, .6, length(fc - mid)) * 100.0;

	//Twister
vec3 col = vec3(0.0, vec2(1.0) - p);
float frq = fc.y * 0.008;
float pif = 3.1415926 * 2.0;
int seg = int((sin(time) +1.0)* 16.0 + 3.0 );

	
	
int ctr = int(resolution.x/2.0) + int(sin(time+ frq) * sin(time) * 100.0);
	
for(int i = 0; i < maxseg; i++)
{
	if(i >= seg)
		break;
float rot = 2.0;
float f = pif / float(seg);
int v = ctr + int(sin(time*rot+f * float(i) + frq) * 100.0);
int v2 = ctr + int(sin(time*rot + f * float(i+1) + frq) * 100.0);
 
if(int(fc.x) >= v && int(fc.x) < v2)
{
 
float d = abs(fc.x - float(v)) / abs(float(v - v2));
float tx = d * 0.125 + 0.125 * float(i);
d = d * (1.0 - d) * 4.0;
col = vec3(d, 1.0 - d, 1.0);
}
}
	
	
	
  gl_FragColor = vec4(col, 1.0);    
}