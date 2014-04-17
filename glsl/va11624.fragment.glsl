
#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 resolution;

const float recursion_level = 8.0;


void main(void)
{

	vec2 position = vec2((gl_FragCoord.x / resolution.x), (gl_FragCoord.y / resolution.y));
	vec2 coord = mod(position,1.0);	
	vec2 centered_coord = coord - vec2(0.5);
	float gradient = 0.0;
	
	for (float i=1.0; i<=20.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 5.0, sin(i*i*i)* 5.0);
		//vec2 star_pos = vec2(sin(i) * 64.0, sin(i*i*i) * 64.0);
		float z = mod(i*i - 50.0*time, 256.0);
		float fade = (256.0 - z) / 256.0;
		vec2 blob_coord = star_pos / z;
		gradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 1.5)) * (fade * fade);
	}
	vec3 color = vec3(0.0);
	gl_FragColor = vec4(gradient * 2.0, gradient, gradient / 2.0,0);
}
