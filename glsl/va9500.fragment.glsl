//
// Cellular Colorspiller Fun
//
// http://twitter.com/rianflo
//
//

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;


vec3 nrand3( vec2 co )
{
	vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
	vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
	vec3 c = mix(a, b, 0.5);
	return c;
}

void main( void ) 
{
	vec2 D = vec2(1.0)/resolution;
	vec2 m  = mouse*resolution;
	vec2 uv = gl_FragCoord.xy / resolution;
	
	// sample 8-neighborhood
	vec4 dL = texture2D(bb, uv+vec2(-D.x, 0.0));
	vec4 dR = texture2D(bb, uv+vec2(D.x, 0.0));
	vec4 dU = texture2D(bb, uv+vec2(0.0, D.y));
	vec4 dD = texture2D(bb, uv+vec2(0.0, -D.y));
	vec4 dUL = texture2D(bb, uv+vec2(-D.x, D.y));
	vec4 dUR = texture2D(bb, uv+vec2(D.x, D.y));
	vec4 dLL = texture2D(bb, uv+vec2(-D.x, -D.y));
	vec4 dLR = texture2D(bb, uv+vec2(D.x, -D.y));
	
	// PLAY WITH ME:
	// ====================================
	vec4 s = (dL*dR+dU+dD+dUL+dUR+dLL*dLR);
	// ====================================
	vec4 val = vec4(normalize(s.xyz), s.w / 8.0);
	
	val = (length(gl_FragCoord.xy - m.xy) <= 50.0) ? vec4(nrand3(mouse.xy), 0.2) : val;
	val /= val.w;
	gl_FragColor = vec4(val);

}