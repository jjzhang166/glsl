#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	float col = 1.0 - floor(abs(mod(gl_FragCoord.x - 0.5, 10.0) * mod(gl_FragCoord.y - 0.5, 10.0)));
	col *= length(gl_FragCoord.xy - mouse.xy * resolution.xy) / 50.0;
	
	vec2 bc = gl_FragCoord.xy - resolution / 2.0;
	if (length(bc) > 100.0)
		bc = normalize(bc);
	bc = gl_FragCoord.xy - bc;
	bc /= resolution;
	vec3 bcol = texture2D(backbuffer, clamp(bc, 0.0, 1.0)).rgb;

	if (texture2D(backbuffer, vec2(0.0, 0.0)).r < 0.5)
		gl_FragColor = vec4(col, 0.0, 0.0, 1.0);
	else
	{
		if (gl_FragCoord.xy == 0.5)
			gl_FragColor = vec4(col);
		else
			gl_FragColor = vec4(bcol, 1.0);
	}
}