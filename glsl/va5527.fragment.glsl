#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

/* Yet another mandlebrot set
 * with code hidden click and drag left/right mouse buttons to translate/zoom
 */

#define ITERATIONS 500

vec3 knockout_color = vec3(0.0,0.0,0.0);
vec3 color_weight = vec3(6.0, 4.0, 2.0);

void main( void ) {
	float color_intensity = 0.0;
	vec2 starting_pos = 2.0 * ( surfacePosition.xy );
	
	float min_im = -1.5;
	float max_re =  1.0;
	float min_re = -0.0;	
	float max_im = min_im + (max_re - min_re);

	float c_re = min_re + starting_pos.x;
	float c_im = max_im - starting_pos.y;
	float z_im = c_im;
	float z_re = c_re;
	
	float r = pow(2.0, -1.0) - pow(2.0, -2.0);
	float r_sq = r*r;
	float z_re_sq = z_re*z_re;
	float z_im_sq = z_im*z_im;
	
	if (   (z_re_sq + z_im_sq - r_sq)
	      *(z_re_sq + z_im_sq - r_sq) < 
	       4.0*r*r
	      *((z_re-r)*(z_re-r) + z_im_sq) 
	   ) 
	{
		// Quick knockout main cardiod
		gl_FragColor = vec4(knockout_color,1.0);	
		
	} else if ( 
		(z_re+1.0)*(z_re+1.0) + z_im_sq < r_sq
	   ) 
	{
		// Quick knockout period 2 disk
		gl_FragColor = vec4(knockout_color,1.0);	
		
	} else {
		color_intensity = 1.0;
		for( int iteration=0; iteration<ITERATIONS; iteration++ ) {
			z_re_sq = z_re*z_re;
			z_im_sq = z_im*z_im;
			if (z_re_sq + z_im_sq > 4.0) {
				color_intensity = float( iteration ) * 0.0005;
				break;
			}
			z_im = 2.0*z_re*z_im + c_im;
			z_re = z_re_sq - z_im_sq  + c_re;
		}
		gl_FragColor = vec4( color_intensity * color_weight, 1.0 );
        }
}