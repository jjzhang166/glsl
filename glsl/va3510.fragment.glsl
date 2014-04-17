#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float f(float x, float y) {
	//x = (mouse.x*10.0)*x; //Interactive
	
	float nx = x + cos(time*x);
	float ny = y - sin(time*y);
	
	float formula = 1.0/( sin( 3.14 + x + time ) - y );
	float formula_effects = formula/ny;
	
	return formula_effects;
}

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	float radio_pacman = 60.0 ;
	float angle;
	vec2 centro = resolution.xy/2.0;
	
	vec2 horizontal;
	horizontal.x = resolution.x;
	horizontal.y = resolution.y/6.0;
	horizontal = normalize(horizontal);
	
	vec2 orientacion = normalize(position - centro );
	float aux = sin(time*5.);
	
	if(aux < -0.2)
	{
	    aux = -aux;	
	}
	
	
	angle = acos(dot(horizontal, orientacion * aux));
	
	
	if((distance(position,centro) < radio_pacman) && angle > .8)
	{
		gl_FragColor = vec4( 1.0,1.0,0.0, 1.0 );
	}
	else
	{
		// CONTROLS
		 float zoom =5.0;
		 float cameraX = 6.0;
		 float cameraY = (zoom*5.0)/10.0-0.5;
		 
		// ^ ^ ^ ^ 
		
		zoom += 0.5;
		vec2 p = ( gl_FragCoord.xy /(resolution.x * 1.0/zoom));
		float x = p.x - cameraX;
		float y = p.y - cameraY;
		
		float a = f(x,y);
		
		gl_FragColor = vec4(sqrt(a)/10.0,  sqrt(a)/8.0,  sqrt(a)/5.0,  1.0);
	}
}