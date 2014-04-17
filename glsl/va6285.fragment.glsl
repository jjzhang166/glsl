#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 discretize_tc(vec2 tc, vec2 res, out vec2 tc2)
{
	tc *= res;
	
	vec2 discrete_tc = tc;
	
	//offset alternate columns
	float offset = mod(floor(discrete_tc.y), 2.0) * 0.5;
	discrete_tc.x += offset;
	
	tc2 = discrete_tc;
	
	discrete_tc.x = floor(discrete_tc.x);
	discrete_tc.y = floor(discrete_tc.y);

	return discrete_tc;
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy);

	p -= 0.5;
	p *= 2.0;

	p.x *= resolution.x/resolution.y;
	
	vec2 lowres = vec2(10.0);

	vec2 p2 = p;
	//p2 *= lowres;
	//p2.y += 0.5 * mod(floor(p2.x), 2.0);
	
	p = discretize_tc(p, lowres, p2);

	vec2 spot_dist = p-p2;
	spot_dist += 0.5;
	
	//spot_dist = vec2(spot_dist.y);
	
	p /= lowres;
	
	vec2 c = p - vec2(sin(time), cos(time*1.3)) * 0.3;
	float r = clamp(dot(c, c), 0.0, 1.5);
	
	r = smoothstep(0.0, 0.5 + 0.4 * sin(2.3*time), r);
	
	float  darken = 0.5;
	r -= darken; 
    	r = clamp(r, 0.0, 1.0);

	
	vec3 colour = vec3(r);
	
	float spot_amount = length(spot_dist) * 2.0;
	
	bool negative = true;
	if(negative)
	{
		//scale by colour
		spot_amount /= (1.0-r);
		//sharpen
		spot_amount = smoothstep(0.8, 1.0, spot_amount);
	}
	else
	{
		//scale by colour
		spot_amount /= (r);
		//sharpen
		spot_amount = smoothstep(1.0, 0.8, spot_amount);
	}
	
	colour = vec3(spot_amount);
	gl_FragColor = vec4(colour, 1.0 );

}