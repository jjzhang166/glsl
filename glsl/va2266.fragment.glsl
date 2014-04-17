#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/**
 
Not finished! Working draft.. 

 Simple Mandelbrot Set Experiment
 
 -Emin Kura ( eminkura.com )

*/

// You can set hue to change color
float hue = 180.0;


vec3 hslToRgb( float h, float s, float l ){
	
    float c = (1.0 - abs( l * 2.0 - 1.0)) * s;
    
    int hh = int(h) / 60;
    
	
    float x = c * ( 1.0 - abs( mod( float(hh), 2.0) - 1.0 ) );
    
    float r1 = 0.0, g1 = 0.0, b1 = 0.0;
    
    if(hh >= 0 && hh < 1){
        r1 = c;
        g1 = x;
        b1 = 0.;
    }else if(hh >= 1 && hh < 2){
        r1 = x;
        g1 = c;
        b1 = 0.;
    }
    else if(hh >= 2 && hh < 3){
        r1 = 0.;
        g1 = c;
        b1 = x;
    }
    else if(hh >= 3 && hh < 4){
        r1 = 0.;
        g1 = x;
        b1 = c;
    }
    else if(hh >= 4 && hh < 5){
        r1 = x;
        g1 = 0.;
        b1 = c;
    }
    else if(hh >= 5 && hh < 6){
        r1 = c;
        g1 = 0.;
        b1 = x;
    }
    
    float m = l - .5 * c;
    
    float r = r1 + m;
    float g = g1 + m;
    float b = b1 + m;
    
   return vec3( r, g, b );	
}

void main( void ) {

		
		
		// Real x and y coordinates of screen
		float x = gl_FragCoord.x ;
		float y = gl_FragCoord.y ;
	
		float size = resolution.y;
		
		float factorX = 4. / size;
		float factorY = 4. / size;
		
		float im = -2. + y * factorY;
		float re = -2. + x * factorX;
	
		bool isDraw = true;
		int c = 0;
	
		float oldA = re;
		float oldB = im;
		float cA = re;
		float cB = im;
		
		for( int i = 0; i < 1024; i++ ){
			
			// zn ^ 2	
			float tempA = oldA * oldA - oldB * oldB;
			float tempB =  oldA * oldB + oldB * oldA;


			float a = tempA + cA;
			float b = tempB + cB;

			if( a * a + b * b > 4.0 ){
				isDraw = false;
				break;
			}
			
			oldA = a;
			oldB = b;
			isDraw = true;
			
		  c++;
		}
	
	vec3 color = vec3( 0.0, 0.0, 0.0 );
	
	
	float col = float( c ) / 30.;

	if( !isDraw ){
	  color = hslToRgb( hue, 1.0, col );
	}
	
	
	
	gl_FragColor = vec4( color, 1.0 );

	
	
	
}