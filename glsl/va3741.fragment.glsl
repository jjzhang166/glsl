#ifdef GL_ES
precision mediump float;
#endif

// Kind of particle flow or whatever... by Kabuto


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 col = vec3(0.0);
	
	vec4 t = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(0,1)) / resolution.xy );
	vec4 tl = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(-1,1)) / resolution.xy );
	vec4 tr = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(1,1)) / resolution.xy );
	vec4 b = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(0,-1)) / resolution.xy );
	vec4 bl = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(-1,-1)) / resolution.xy );
	vec4 br = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(1,-1)) / resolution.xy );
	vec4 l = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(-1,0)) / resolution.xy );
	vec4 r = texture2D(backbuffer, ( gl_FragCoord.xy - vec2(1,0)) / resolution.xy );
	vec4 c = texture2D(backbuffer, ( gl_FragCoord.xy ) / resolution.xy );
	
	float cf = (.5-abs(c.b-.5))*(.5-abs(c.a-.5));
	float tf = (.5-abs(t.b-.5))*max(0.,.5-t.a);
	float tlf = max(0.,.5-tl.b)*max(0.,.5-tl.a);
	float trf = max(0.,tr.b-.5)*max(0.,.5-tr.a);
	float bf = (.5-abs(b.b-.5))*max(0.,b.a-.5);
	float blf = max(0.,.5-bl.b)*max(0.,bl.a-.5);
	float brf = max(0.,br.b-.5)*max(0.,br.a-.5);
	float lf = (.5-abs(l.a-.5))*max(0.,.5-l.b);
	float rf = (.5-abs(r.a-.5))*max(0.,r.b-.5);
	float sum = cf+tf+bf+lf+rf+tlf+trf+blf+brf;
	
	vec4 newval = (t*tf+b*bf+l*lf+r*rf+c*cf+bl*blf+br*brf+tl*tlf+tr*trf)/vec4(.245,.25,sum,sum);
	
	gl_FragColor = distance(position,mouse) < .02 ? fract(vec4(.134,.6724,.423,.12454)*dot(position,position)*fract(time)*9000.) : dot(c,vec4(1.))==0. ? vec4(0,0,.5,.5) : newval;

}