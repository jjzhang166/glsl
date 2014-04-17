#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	float col = 1.0 - floor(abs(mod(gl_FragCoord.x - 0.5, 10.0) * mod(gl_FragCoord.y - 0.5, 10.0)));
	
	vec3 bcol = texture2D(backbuffer, gl_FragCoord.xy / resolution).rgb;
	bcol *= length(gl_FragCoord.xy - mouse.xy * resolution.xy) / 50.0;
	
	float pcolv = mod(time * 0.0 - length(gl_FragCoord.xy - resolution / 2.0) / 20.0, asin(1.0) * 4.0);
	float scolv = sin(pcolv);
	vec3 nv = vec3(scolv);
	
	float colv = (scolv + 1.0) / 2.0;
	float tanv = (tan(time * 0.0 - length((gl_FragCoord.xy - resolution / 2.0) / 20.0)) + 1.0) / 2.0;
	vec3 d3 = vec3(gl_FragCoord.xy / resolution, colv);
	vec3 dm = vec3(mouse, 1.0);
	
	float light = (1.0 - length(dm - d3));

/*	if (mouse.x < 0.1 && mouse.y < 0.1)
		gl_FragColor = vec4(col, 0.0, 0.0, 1.0);
	else
	{
		if (gl_FragCoord.xy == 0.5)
			gl_FragColor = vec4(col);
		else*/
			gl_FragColor = vec4(scolv);
//	}
}