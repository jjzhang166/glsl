#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 SetColor()
{
	vec4 ambientC = vec4(0.2,0.2,0.2,1.0);
	vec4 diffuseC = vec4(0.3,0.6,0.3,1.0);
	vec4 specularC= vec4(0.2,0.6,0.3,1.0);
	
	
	// Calculate the ambient term
	vec4 ambient_color = ambientC; //* gl_LightSource[0].ambient;

	// Calculate the diffuse term
	vec4 diffuse_color = diffuseC; //* gl_LightSource[0].diffuse;


	// Set the diffuse value (darkness). This is done with a dot product between the normal and the light
	// and the maths behind it is explained in the maths section of the site.
	//float diffuse_value = max(dot(vertex_normal, vertex_light_position), 0.0);


	// Set the output color of our current pixel
	
	if(gl_FragCoord.xy.x < 350.0)
	return (ambient_color + diffuse_color);
	else
	return vec4(0.0,0.1,0.2,1.0);

}


void main()
{
	gl_FragColor = SetColor();

}