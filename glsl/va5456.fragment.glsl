////////////////////////////////
// Inspired by geometry wars  //
////////////////////////////////////////////////////
//  Grid is done, now I need the pinching effect  //
////////////////////////////////////////////////////

// @Flexi23: added complex distortion from http://glsl.heroku.com/e#5189.0 - now modulo looks awful, better try smoothstep/distance-based grid?

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 complex_div(vec2 numerator, vec2 denominator){
   return vec2( numerator.x*denominator.x + numerator.y*denominator.y,
                numerator.y*denominator.x - numerator.x*denominator.y)/
          vec2(denominator.x*denominator.x + denominator.y*denominator.y);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );
	p = mix( -0.5 + (p- 0.5)*8., complex_div(vec2(0.25,.0), p - mouse) + 0.5, 0.5); 

	
	float grid_width = 40.0;
	float duller = 0.7;
	float max_dist = 0.6;

	//calculate the sub grid
	float sub_color = 1.0 - min(mod(p.x*resolution.x,grid_width/2.0), mod(p.y*resolution.y, grid_width/2.0));
	sub_color *= 0.3;
	
	//calculate the full grid
	float full_color = 1.0 - min(mod(p.x*resolution.x,grid_width), mod(p.y*resolution.y, grid_width));
	
	//now select the sub or full color
	float color = max(sub_color, full_color);
	
	//now find the distance this pixel is from the mouse, 
	//and use its distance to gradient into black
	float dist = 1.0 - distance(gl_FragCoord.xy/resolution.xy, mouse)/max_dist;
	
	color *= max(dist,0.0);
	
	gl_FragColor = vec4(color*duller, min(1.0, color*2.0)*duller, color*duller, 1.0);
}