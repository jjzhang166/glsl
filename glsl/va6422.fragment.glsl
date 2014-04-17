//Fancy tile-scroller-thing.
//Written by Liam S. Crouch Aka petterroea
//
//I tried to mimic a classic C64 effect with GLSL
//
//Don't make fun of my code
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 color1 = vec3(0.4, 0.4, 1.0);
	vec3 color2 = vec3(1.0, 0.4, 1.0);
	vec3 colorOut = vec3(0.0, 0.0, 0.0);
	float x = gl_FragCoord.x/((resolution.x/20.0)/sin(time/3.0));
	float y = gl_FragCoord.y/((resolution.x/20.0)/sin(time/3.0));
	//Treated X and y
	float treatedx = mod(x+(sin(time/10.0)*20.0), 2.0);
	float treatedy = mod(y+(sin(time/8.0)*20.0), 2.0);
	if(treatedx<1.0)
	{
	    if(treatedy<1.0)
	    {
		colorOut = color1;
	    }
	    else
	    {
	        colorOut = color2;		
	    }
	}
	else
	{
	    if(treatedy<1.0)
	    {
		colorOut = color2;
	    }
	    else
	    {
	        colorOut = color1;		
	    }	
	}
	gl_FragColor = vec4(colorOut, 1.0);

}