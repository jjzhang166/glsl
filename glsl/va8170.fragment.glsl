#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// An excersize in impractical coding practices
// original: http://glsl.heroku.com/e#8168.0

// + ahh, there's a feedback texture
uniform sampler2D backbuffer;


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position.x = position.x/0.6-0.3 + sin(position.y*2.0+time) * 0.1;
	// feedback color
	vec3 fbc = texture2D(backbuffer, position * vec2(0.5,0.8) + vec2(0.25+0.04*sin(position.y*4.0+1.3*time),0.1)).brg;
	// feedback as background
	vec3 color = 0.8 * fbc;
	
	vec2 face_center = vec2(0.55, 0.5);
	float face_radius = 0.34;
	vec2 cheek_center = vec2(0.5, 0.5);
	vec2 cheek_radius = vec2(1.0, 0.2);
	
	vec3 skin_colour = vec3(1.0, 1.0, 0.8);
	vec3 hair_colour = vec3(0.4, 0.4, 1.0);
	vec3 hair_shade_colour = vec3(0.2, 0.2, 1.0);
	vec3 eye_white = vec3(1.0,1.0,1.0);
	vec3 eye_dark = vec3(0.0,0.0,0.0);
	vec3 blush = vec3(0.8,0.4,0.4);

	// Hair background
	if (pow((position.x-0.55)/1.0,2.0)+pow((position.y-0.43)/1.1,2.0) <= 0.15)
	{
		if (position.y > 0.14+0.01*sin(position.x*100.0))
			color = hair_shade_colour;
	}

	// Face
	if (pow((position.x-0.55)/1.0,2.0)+pow((position.y-0.5)/1.0,2.0) <= 0.1)
	{
		color = skin_colour;
	}

	// Cheeks
	if (pow((position.x-0.5)/0.98,2.0)+pow((position.y-0.32)/0.5,2.0) <= 0.1)
	{
		color = skin_colour;
	}

	// Eye1
	if (pow((position.x-0.35)/0.2,2.0)+pow((position.y-0.5)/0.43,2.0) <= 0.1)
	{
		color = eye_dark;
	}

	// Eye1 white
	if (pow((position.x-0.35)/0.2,2.0)+pow((position.y-0.5)/0.43,2.0) <= 0.04)
	{
		color = eye_white;
	}
	
	// Eye2
	if (pow((position.x-0.59)/0.2,2.0)+pow((position.y-0.5)/0.43,2.0) <= 0.1)
	{
		color = eye_dark;
	}

	// Eye2 white
	if (pow((position.x-0.59)/0.2,2.0)+pow((position.y-0.5)/0.43,2.0) <= 0.04)
	{
		color = eye_white;
	}

	// Blush1
	if (pow((position.x-0.3)/0.3,2.0)+pow((position.y-0.3)/0.20,2.0) <= 0.04)
	{
		color = blush;
	}
	
	// Blush2
	if (pow((position.x-0.59)/0.3,2.0)+pow((position.y-0.3)/0.20,2.0) <= 0.04)
	{
		color = blush;
	}

	// Hair
	if (pow((position.x-0.55)/1.0,2.0)+pow((position.y-0.43)/1.1,2.0) <= 0.15)
	{
		if (position.y > 0.65+0.01*sin(position.x*100.0))
			color = hair_colour;
	}
	
	// Mouth
	vec2 mouth = vec2(0.0,0.0);
	mat2 rot1 = mat2(cos(0.3), -sin(0.3), sin(0.3), cos(0.3));
	vec2 pos = rot1*position;

	vec2 mouth1pos = vec2(0.25,0.6);
	
	// Hair
	if (mouth1pos.y+pos.y > 0.695 && mouth1pos.y+pos.y < 0.7 && mouth1pos.x+pos.x > 0.69 && mouth1pos.x+pos.x < 0.75 )
		color = vec3(0.0, 0.0, 0.0);
	
	
	gl_FragColor = vec4( color, 1.0 );
}