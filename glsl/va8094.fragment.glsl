#ifdef GL_ES
precision mediump float;
#endif

/* What would be an efficient way to cap the line at both points?
 * Any help would be appreciated!
*/

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 pt_a = vec2(0.1, 0.1);
vec2 pt_b = vec2(0.7, 0.5);
float width = 0.04;

vec4 solid_point(vec2 center, float size, vec4 point_color, vec4 bg_color, vec2 coord) 
{
	float dist = length(center - coord);
	dist = (dist - size);
	return mix(point_color, bg_color, smoothstep(0., size, dist));
		 
}

float dist_to_line(vec2 line_pt_a, vec2 line_pt_b, vec2 pt)
{
	vec2 line_pt, line_vec;
	float dist;
	
	line_pt = line_pt_a;
	
	// create a vector that is perpendicular to the line. In 2D
	// this is simple achieved by exchangin the x- and y component
	// and changing the sign of one.
	line_vec = line_pt_b - line_pt_a;
	line_vec = normalize(line_vec);
	line_vec = vec2(-line_vec.y, line_vec.x);
	
	//substitute into the line equation:
	// a*x + b*y + c = 0
	// The perpendicular vector gives us a and b.
	
	// The c-component is obtained by solving the equation
	// for c:
	// c = -(a*x + b*y)
	// We use a and b and we substitue x and y with the
	// starting point of our line. 
	float a,b, c;
	a = line_vec.x;
	b =  line_vec.y;
	c = -(line_pt.x * a + line_pt.y * b);
	
	// now we just need to substitute out values
	dist = (a * pt.x + b * pt.y + c);
	
	return dist;
}

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) / 1.0;
	
	vec4 color = vec4(1.);
	
	float dist = dist_to_line(pt_a, pt_b, position);
		
	// we use the abs() function to get only positive distance
	// values (points on the other side of the line would yield 
	// negative values otherwise.
	float line_range = smoothstep(0., width, abs(dist));
	color = mix(vec4(0.), vec4(1.), line_range);
	
	color = solid_point(pt_b, 0.015, vec4(0.22, .4, 0.77, 1), color, position);
	gl_FragColor = solid_point(pt_a, 0.015, vec4(0., .7, 0.2, 1.), color, position);
}