/* original: lame-ass tunnel by kusma */

// parent tunnel is still mostly there when you bring the mouse to the top right area of screen.
// vertical axis = number of branches and chirality
// horizontal axis = color tweaks++. also rotation angle.
// mouse on right edge + exactly in the horizontal middle = moire effect.
// Keeping the mouse on the left edge and moving it vertically may result in seizures, motion sickness, etc.
// But it also shows a weird little remanent effect. Worth it.

#ifdef GL_ES
precision mediump float;
#endif

// changing this is unwise.
#define PI 3.1415926535

// these are RGB numbers. Go nuts, change them to make a green/red tunnel!
#define BEAM1_COLOR vec3(1.0, 0.8, 0.9)
#define BEAM2_COLOR vec3(0.8, 0.9, 1.0)
#define BEAM3_COLOR vec3(0.9, 0.8, 1.0)
#define BG_COLOR    vec3(0.1, 0.1, 0.2)

#define TUNNEL_SPEED 1.
#define ANGULAR_SPEED 0.2

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	float y1 = floor(1./(mouse.y-.5));
	float th = atan(position.y, position.x) / (2.0 * PI) * y1 + 0.5 + time*ANGULAR_SPEED + mouse.x;
	float dd = length(position);
	float d = 0.25 / dd + time*TUNNEL_SPEED;
	
	vec3 uv = vec3(th + d, th - d, th + sin(d) * 0.1);
	float a = 0.5 + cos(uv.x * PI * 2.0) * 0.5;
	float b = 0.5 + cos(uv.y * PI * 2.0) * 0.5;
	float c = 0.5 + cos(uv.z * PI * 6.0) * 0.5;
	vec3 color = mix(BEAM1_COLOR, BG_COLOR, pow(a, 0.2)) * 3.;
	color     += mix(BEAM2_COLOR, BG_COLOR, pow(b, 0.1)) * 0.75;
	color     += mix(BEAM3_COLOR, BG_COLOR, pow(c, 0.1)) * 0.75;
	vec4 p_out = vec4(color  * clamp(dd/1., 0.0, 1.0), 1.0);
	vec4 p_in = texture2D(backbuffer, gl_FragCoord.xy/resolution);
	// avoid the initial black screen
	if (p_in.rgb == vec3(0.,0.,0.)) { p_in = p_out; }
	// left side = new color/old color with a little bit of old color mixed in
	// right size = new color ( = plain tunnel )
	gl_FragColor = mix( p_out/p_in.rbga, mix(p_in, p_out, mouse.x) , mouse.x);
}