#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

vec3 fade(vec3 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}
	
void main( void ) {
	vec3 curr_color = vec3(0.0, 0.0, 0.0);
	
	float scale = sin(0.3 * time) + 5.0;
	vec2 position2 = ((((gl_FragCoord.xy / resolution )) - 0.5) * scale);
	float gradient = 0.0;
	vec3 color = vec3(0.0);
	float fade = 0.0;
	float z = 0.0;
	float time2 = time + mouse.x / 1.0;
 	vec2 centered_coord = position2 - vec2(sin(time2*0.1) + mouse.x / 1.0,sin(time2*0.1) + mouse.y / 1.0);
	
	for (float i=1.0; i<=200.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 250.0, sin(i*i*i) * 250.0);
		float z = mod(i*i - 10.0*time, 256.0);
		float fade = (256.0 - z) /256.0;
		vec2 blob_coord = star_pos / z;
		gradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 1.5)) * ( fade);
	}

	curr_color += gradient;
	
	gl_FragColor = vec4(curr_color, 1.0);
}