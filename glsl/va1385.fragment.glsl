// Starfield effect, extracted from: http://glsl.heroku.com/e#883.0

#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand (float x) {
	return fract(sin(x * 24614.63) * 36817.342);	
}

void main(void)
{
	float scale = sin(0.1 * time) * .5+ 4.0;
	float distortion = resolution.y / resolution.x;

	vec2 position = (((gl_FragCoord.xy * 1.8 / resolution) ) * scale) + scale*0.1;
	position.y *= distortion;

	float gradient = 0.0;
	vec3 color = vec3(0.0);
 
	float fade = 0.3;
	float z;
 
	vec2 centered_coord = position - vec2(3.0);

	for (float i=10.0; i<=50.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 300.0, sin(i*i*i) * 300.0);
		float z = mod(i*i - 50.0*time, 512.0);
		float fade = (256.0 - z) /200.0;
		vec2 blob_coord = star_pos / z;
		gradient += ((fade / 1800.0) / pow(length(centered_coord - blob_coord ), 1.5)) * ( fade);
	}

	color = vec3( gradient * 3.0 , max( rand (gradient*1.0)*0.2 , 4.0*gradient) , gradient / 2.0 );

	gl_FragColor = vec4(color, 1.0 );
}

