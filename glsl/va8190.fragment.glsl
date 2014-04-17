#ifdef GL_ES
precision mediump float;
#endif

/** good'ol vga fire

    2013/04/19 def.gsus @ modular-audio-graphics.com

    nobody's ever gonna find this, because the preview thumbs don't work with feedback on glsl.heroku
*/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// seems, regardless of name, every texture links to the last rendered frame
uniform sampler2D tex;

/* great random function from somewhere down the tree: http://glsl.heroku.com/e#8176.2 */
float rand( vec2 n ) 
{
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233))) * 43758.4453 * sin(time));
}

// return pixel color (pixel_pos = [0,resolution]) 
vec3 pixel(vec2 pixel_pos)
{
	return texture2D(tex, pixel_pos / resolution.xy).rgb;
}

// return (for-fire-tuned) average pixel color (p = [0,resolution]) 
vec3 av_pixel(vec2 p)
{
	vec3
	c  = pixel( p + vec2(-1.0, -1.0) );
	c += pixel( p + vec2( 0.0, -1.0) );
	c += pixel( p + vec2( 1.0, -1.0) );
	c += pixel( p + vec2(-2.0, -2.0) );
	c += pixel( p + vec2( 0.0, -2.0) );
	c += pixel( p + vec2( 2.0, -2.0) );
	c += pixel( p + vec2(-3.0, -4.0) );
	c += pixel( p + vec2( 0.0, -5.0) );
	c += pixel( p + vec2( 3.0, -4.0) );
	c /= 9.0;
	
	// increase contrast
	c = (c-0.5) * 1.03 + 0.5;
	
	return c;
}

void main( void ) 
{
	// pixel pos
	vec2 ppos = gl_FragCoord.xy;
	
	vec3 color;
	
	// blured feedback
	color += 0.995*av_pixel(ppos);
	
	// noise on the bottom line
	if (ppos.y<1.0)
		color = vec3( rand( floor(ppos / 10.0) ) );	
	
	// palette
	color = vec3(smoothstep(0.0, 0.5, color.r), color.g, smoothstep(0.3,1.0,color.b));

	gl_FragColor = vec4( color, 1.0 );

}