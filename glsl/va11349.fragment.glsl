#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 tri(vec2 p, float r)
{
	p *= r;
	vec2 x = fract(p);
	
	// Solid coloring
	//vec2 i = p - x;
	
	// Gradient coloring (cycles w/ time)
	vec2 i = p - time / 2.0;
	// Solid coloriing - (cycles w/ time)
	//i = p - x - time/2.0;
	
	vec3 c = vec3(sin(i.x*2.0), cos(i.y*2.0), 0.0)*0.2+0.2;
	//return ((x.y < x.x) ? 1.0 : 0.0) * c;
	
	// Serpinski effect
	//x -= time*0.01;
	
	return (((x.x < x.y) == (x.x < 1.0 - x.y)) ? 1.0 : 0.0) * c;
	//return c;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xx );
	//p -= mouse;
	float zoom = 1.1 + sin(time*0.5);
	//p -= time*0.01;
	
	// scaling
	p = (p / 2.5);
	
	// speed
	
	// movement (sign == direction)
	p -= time / 20.0;

	//p = p  2
	const float r = 20.0;
	vec2 x = fract(p*r);
	vec2 i = p*r - x;
	
	const float line_width = 80.0;
	
	
	
	float l = 0.0;
	// Verical line - hypotenuse 
	l = clamp(0.0, 1.0, (0.5 - abs(x.x-0.5))*line_width);
	
	l = clamp(0.0, 1.0, (0.5 - abs(x.x-0.5))*line_width);
	
	// Horizontal Lines
	l *= clamp(0.0, 1.0, (0.5 - abs(x.y-0.5))*line_width);
	
	// Diagonal Line - bottom left to top right 
	l *= clamp(0.0, 1.0, abs(x.x - x.y)*line_width);
	
	// Diagonal Line - top left to bottom right
	l *= clamp(0.0, 1.0, abs(1.0 - x.x - x.y)*line_width);
	
	vec3 c = vec3(sin(i.x*0.3), cos(i.y*0.3), 0.0)*0.5+0.5;
	vec3 c2 = vec3(cos(i.x*0.3), sin(i.y*0.3), 0.0)*0.5+0.5;
	//vec3 tc = mix(c, c2, x.x > x.y ? 1.0 : 0.0);	
	//vec3 tc = mix(c, c2, ((x.y < x.x) == (x.y < 1.0 - x.x)) ? 1.0 : 0.0);
	
	vec3 tc = tri(p, r);
	tc += tri(p, r*0.5);
	tc += tri(p, r*0.25);
	tc += tri(p, r*0.125);
	
	//gl_FragColor = vec4(x, 0.0, 1.0 );	
	//gl_FragColor = vec4(i*0.1, 0, 1);
	//gl_FragColor = vec4(c, 1.0 );
	//gl_FragColor = vec4(vec3(l), 1.0 );	
	gl_FragColor = vec4(tc*l, 1.0 );
}
/*
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 tri(vec2 p, float r)
{
	p *= r;
	vec2 x = fract(p);
	
	// Solid coloring
	//vec2 i = p - x;
	
	// Gradient coloring (cycles w/ time)
	vec2 i = p - time / 1.2;
	// Solid coloriing - (cycles w/ time)
	//i = p - x - time/2.0;
	
	vec3 c = vec3(sin(i.x*2.0), cos(i.y*2.0), 0.0)*0.2+0.2;
	//return ((x.y < x.x) ? 1.0 : 0.0) * c;
	
	// Serpinski effect
	//x -= time*0.01;
	
	return (((x.x < x.y) == (x.x < 1.0 - x.y)) ? 1.0 : 0.4) * c;
	//return c;
}

void main( void ) {

	float scaling = 3.0;
	vec2 p = (gl_FragCoord.xy / (resolution.xy * scaling) );
	
	float tri_width = 1.875;
	p -= (gl_FragCoord.xz / (resolution.xy *  tri_width));// * scaling) );
	
	p += cos(time * 0.01); 
	
	//p -= mouse;
	//float zoom = 1.1 + sin(time*0.5);
	//p -= time*0.01;
	
	// scaling
	//p = (p / 2.5);
	
	// speed
	
	// movement (sign == direction)
	p -= p / time / 0.001 - gl_FragCoord.z * gl_FragCoord.z;
	//p = p  2
	const float r = 20.0;
	
	// Horizontal line subdivision
	float hsubdivision = 2.0;
	vec2 x = fract(p*r*hsubdivision);
	
	// Diagonal line subdivision
	float dsubdivision = 1.0;
	vec2 y = fract(p*r*dsubdivision);
	
	vec2 i = p*r - x;
	
	const float line_width = 64.0;
	
	float l = 0.0;
	// Verical line - hypotenuse 
	l = clamp(0.0, 1.0, (0.5 - abs(x.x-0.5))*line_width);
	
	l *= clamp(0.0, 0.9, (0.5 - abs(x.x-0.5))*line_width);
	
	// Horizontal Lines
	//l *= clamp(0.0, 1.0, (0.5 - abs(x.y-0.5))*line_width);
	
	// Diagonal Line - bottom left to top right 
	l *= clamp(0.0, 1.0, abs(y.x - y.y)*line_width);
	
	// Diagonal Line - top left to bottom right
	l *= clamp(0.0, 1.0, abs(1.0 - y.x - y.y)*line_width);
	
	//vec3 c = vec3(sin(i.x*0.3), cos(i.y*0.3), 0.0)*0.5+0.5;
	//vec3 c2 = vec3(cos(i.x*0.3), sin(i.y*0.3), 0.0)*0.5+0.5;
	//vec3 tc = mix(c, c2, x.x > x.y ? 1.0 : 0.0);	
	//vec3 tc = mix(c, c2, ((x.y < x.x) == (x.y < 1.0 - x.x)) ? 1.0 : 0.0);
	
	vec3 tc = tri(p, r);
	tc += tri(p, r*.5);
	tc += tri(p, r*0.25);
	tc += tri(p, r*0.125);
	
	//gl_FragColor = vec4(x, 0.0, 1.0 );	
	//gl_FragColor = vec4(i*0.1, 0, 1);
	//gl_FragColor = vec4(c, 1.0 );
	//gl_FragColor = vec4(vec3(l), 1.0 );	
	float gamma = 0.01;
	vec4 color = vec4(tc*l-(time*0.000001), 1.0 ) + gamma;
	
	gl_FragColor = color;

}
*/