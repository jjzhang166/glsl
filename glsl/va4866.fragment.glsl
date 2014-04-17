#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D b;

//anamorphic lens flare test lol
//~MrOMGWTF

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy )*2.0 - 1.0);
	vec2 uv = gl_FragCoord.xy / resolution;
	position.x *= resolution.x / resolution.y;
	vec3 color = vec3(0.0);

	color += vec3(0.25, 1.0, 0.25) * (1.0 / distance(
		vec2((sin(time) + sin(time * 2.)) * 0.5, (cos(time) + cos(time * 2.)) * 0.5)
		, position) * 0.05);
	
	
	color += vec3(0.25, 0.5, 1.0) * (1.0 / distance(
		vec2((sin(time) + sin(time * 4.)) * 0.5, (cos(time) + cos(time * 4.)) * 0.5)
		, position) * 0.05);
	
	
	vec3 flare = vec3(0.0);
	
	for(float i = 0.0; i < 16.0; i++)
	{
		float i2 = 8.0 - i;
		i2 /= 8.0;
		flare += texture2D(b, vec2(uv.x + i2 * 0.25, uv.y)).xyz * 1.0;		
	}
	
	flare /= 24.0;
	
	color += flare;
	
	gl_FragColor = vec4(color, 1.0 );

}