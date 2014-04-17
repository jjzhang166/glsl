#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int nrOfPoints = 3;
float points[nrOfPoints];

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
    	float s = 1.0/mouse.x;
	position.x *= s;
  	float c = float(abs(6.0*position.y-3.0  // y
                         // x
                        - (sin(position.x*10.1) 
                        + 0.9*sin(position.x*11.1 + time )
                        + 0.3*sin(position.x*43.1 + 3.0*time)
                        + 0.2*sin(position.x*143.1 + 5.3*time)
                        //+ 0.1*sin(position.x*543.1 - 3.0*time)
                          )
                        ) < 0.1);
	 

	gl_FragColor = vec4( vec3( c, c, c ), 1.0 );
}