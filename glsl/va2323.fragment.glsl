#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float maxdiv = 10.;

vec3 sea (vec2 coord, vec3 original)
{
	
	float divider;
	for (float divider = 0.; divider < maxdiv; divider += 1.)
	{

	    if (coord.x > (resolution.x/maxdiv) * divider && coord.x < (resolution.x/maxdiv) * (divider+1.)) 
	    {
		   if (coord.x > (resolution.x/maxdiv) * divider + sin(time)*sin(time)*(resolution.x/maxdiv))
		   	return vec3(
				mix(divider*.07,(divider+1.)*.07,sin(time)*sin(time)),
				mix(divider*.07,(divider+1.)*.07,sin(time)*sin(time)),
				1.);
		   else
			return vec3(
				mix((divider-1.)*.07,(divider)*.07,sin(time)*sin(time)),
				mix((divider-1.)*.07,(divider)*.07,sin(time)*sin(time)),
				1.);
	    }
	    
	}
	
}

void main( void ) {

	vec2 coord = gl_FragCoord.xy;
	vec3 color = mix(vec3(.5,.7,1),vec3(.8,.9,1), -(coord.y/resolution.y*.5)+(coord.y/resolution.y)*2.);
	
	if (coord.y < resolution.y*.5)
	{
	    color = sea(coord,color);
	}
	
	gl_FragColor = vec4( color, 1.0 );
}