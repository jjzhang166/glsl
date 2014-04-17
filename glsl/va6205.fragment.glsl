#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;

/* Made by Krisztián Szabó */
void main(){
	/* The light's positions */
	vec2 light_pos = resolution*mouse;
	/* Distance between the fragment and the light */
	float dist = distance(gl_FragCoord.xy, light_pos)*0.0005;
	dist=dist*dist;
	/* Basic light color, change it to your likings */
	vec3 light_color = vec3(0.75, .75, 0.680);
	/* Alpha value of the fragment calculated based on intensity and distance */
	float alpha = 1.0 / (1.0+dist);
	
	/* The final color, calculated by multiplying the light color with the alpha value */
	vec4 final_color = vec4(light_color, 1.)*vec4(alpha, alpha, alpha, 1.0);
	
	gl_FragColor = final_color;
}