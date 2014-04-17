#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

/* Made by Krisztián Szabó */
void main(){
	/* The light's positions */
	vec2 light_pos = resolution*mouse;
	/* The radius of the light */
	float radius = 1000.0;
	/* Intensity range: 0.0 - 1.0 */
	float intensity = 0.01;
	
	/* Distance between the fragment and the light */
	float dist = distance(gl_FragCoord.xy, light_pos)*0.005;
	dist=dist*dist;
	/* Basic light color, change it to your likings */
	vec3 light_color = vec3(1.0, 1.0, 0.9);
	/* Alpha value of the fragment calculated based on intensity and distance */
	float alpha = 1.0 / (1.0+(4.0*dist));
	
	/* The final color, calculated by multiplying the light color with the alpha value */
	vec4 final_color = alpha*vec4(light_color, 1.0);
	
	gl_FragColor = final_color;
}