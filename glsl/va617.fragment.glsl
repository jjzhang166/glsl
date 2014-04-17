/*
By @Stv
alot of effects mixed + some tweaks ....
uncomment the bump define for hummm ... well ... some bump ...
*/

#ifdef GL_ES
precision mediump float;
#endif

// #define BUMP 0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

  	float color = 0.0;
  	color += sin( 10.0*position.x * (cos(0.5*time)+1.4) );
	color += sin( 10.0*position.y * (sin(time) + 2.1 ) );
  	color += sin( 1.1 + distance((10.0 + 40.0 * cos(time))* position, vec2(10.0+11.0*sin(time), 0.0+10.0*cos(time)) ));
  	color += cos( 1.1 + distance((40.0 + 10.0 * sin(time))* position, vec2(10.0+11.0*cos(time), 0.0+10.0*sin(time)) ));
	color += 6.54 * sin(distance(position, vec2(6.25 * cos(time * 0.25), sin(time / 0.65))) + 10.0 * cos(time / 4.75));
	color += 3.41 * cos(distance(position, vec2(4.25 * sin(time * 0.25), cos(time / 0.65))) + 8.0 * sin(time / 1.23));
  	color += 1.79 * sin(distance(position, vec2(2.25 * sin(time * 0.25), sin(time / 0.65))) + 6.0 * cos(time * 0.31));
  
  	color += 3.0;
  
  	gl_FragColor = vec4( vec3( color, color*sin(color+time*1.1314), color*sin(color+time*0.1))/(8.0), 1.0 );
 
#ifdef BUMP
        // Bump mapping starts here
        vec2 uv = position;
        vec2 d = 4./resolution;
        float dx = texture2D(backbuffer, uv + vec2(-1.,0.)*d).x - texture2D(backbuffer, uv + vec2(1.,0.)*d).x ;
        float dy = texture2D(backbuffer, uv + vec2(0.,-1.)*d).x - texture2D(backbuffer, uv + vec2(0.,1.)*d).x ;
        d = vec2(dx,dy)*resolution/1024.;
        gl_FragColor.z = pow(clamp(1.-1.5*length(uv  - mouse + d),0.,1.),4.0);
        gl_FragColor.y = gl_FragColor.z*1.25 + gl_FragColor.x*0.4;
          
        gl_FragColor *=1.25;
#endif
}