#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2  O = vec2(.5,.5) * vec2(512, 512);
float R = 0.20 * resolution.x;

vec2  S = vec2(50, 50); //vec2(.2,.2) * resolution.xy;
//vec2  S = vec2(.1,.1) * resolution.xy * (2.0 + sin(time));

float Thickness = 5.0;

void main( void ) 
{

	vec2 uv = gl_FragCoord.xy;
			
	
	// Circle
	float circle = clamp( abs(distance(O, uv) - R) - Thickness, 0.0, 1.0);	
	vec4 circleColor = circle + vec4(1, 0.5, 0, 1);
	circleColor.a = circle;
	
	// Rectangle
	vec2 D = abs(uv - O) - S;
	float rectangle = clamp(abs(min(max(D.x, D.y), 0.0)) + length(max(D, 0.0)) - Thickness, 0.0, 1.0);
	vec4 rectangleColor = rectangle + vec4(0, 1, 0, 1);
	rectangleColor.a = rectangle;
	
	/*
	float lines = 1.0;
	if (D.x <= 0.0)
		lines = clamp( abs(min(D.y, 0.0)) + length(max(D.y, 0.0)) - Thickness, 0.0, 1.0);
	*/	

	float lines = mix(1.0, clamp( abs(min(D.y, 0.0)) + length(max(D.y, 0.0)) - Thickness, 0.0, 1.0), step(D.x, 0.0));
	
	
	vec4 Lines = lines + vec4(1, .5, 0, 0);
	
	float Vertical_Lines = abs(min(D.x, - Thickness)) + length(max(D, 0.5)) - Thickness;
	
	
	// Instead of Conditional below?
	//vec4 col = mix(Horizontal_Lines + vec4(0, 0, 1, 0), Horizontal_Lines + vec4(0, 1, 0, 1) , step(O.y, uv.y));  
	 

	
	gl_FragColor = Lines; //min(Lines, rectangleColor); // ;mix(rectangleColor, circleColor, 1.0 + (.0 - circleColor.a) - (.0 - rectangleColor.a)); 
	
	//gl_FragColor = vec4(1.0 - rectangleColor.a);
	/*
	if (Horizontal_Lines == 0.0)
	{	
		if (uv.y > O.y)
		{		
			gl_FragColor = vec4(1, .6, .0, 0); 
			return;
		}
		else
		{
			gl_FragColor = vec4(0, .75, .2, 0); 
			return;
		}
	}
	else
	{	
		Horizontal_Lines /= 5.0;	
	}
	
	
	gl_FragColor = vec4(min(Horizontal_Lines, Vertical_Lines));
	*/
}