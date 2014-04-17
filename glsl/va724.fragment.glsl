// by @neave and weyland yutani
// Inspired by http://www.everyday3d.com/j3d/demo/011_Plasma.html

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 col1 = vec3(.964705882, .990196078, .990196078);
const vec3 col2 = vec3(.266666667, .333333333, .231372549);
const vec3 col3 = vec3(.839215686, .880392157, .849019608);
const vec3 col4 = vec3(.776470588, .772549020, .729411765);
const vec3 col5 = vec3(.509803922, .592156863, .503921569);

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
  	
	vec2 ca = vec2(0.1, 0.2);
	vec2 cb = vec2(0.7, 0.9);
	float da = distance(position, ca);
  	float db = distance(position, cb);
	
  	float t = time * 0.1;
	float c1 = sin(da * cos(t) * 18.0 + t * 10.0);
	float c2 = cos(position.y * 1.0 + t);
	float c3 = cos(db * 19.0) + sin(t);
	
	float p = (c1 + c2 + c3) / 3.0;
  	vec4 col = vec4(0, 0, 0, 1);
  	
  	if (p <= 0.0) col.rgb = col1;
  	else if (p < 0.2) col.rgb = col2;
  	else if (p < 0.3) col.rgb = col3;
  	else if (p < 0.4) col.rgb = col4;
  	else col.rgb = col5;
	
	gl_FragColor = col;
}