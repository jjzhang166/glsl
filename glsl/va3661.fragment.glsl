// rotwang @mod+ spiral function, @mod* effect with 2 rotating spirals

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

const float threshold = 20.0;
const float PI = 3.1415;
const float TWOPI = 2.0*PI;



float spiral(vec2 p, float rpm, float blades, float rings)
{
	float t = time * rpm/60.0;
	p *= mat2(vec2(cos(t*TWOPI),sin(t*TWOPI)),vec2(-sin(t*TWOPI),cos(t*TWOPI)));
	vec2 c = vec2(0.0);
	float dist = distance(p, c)*TWOPI*rings*blades;
	dist = pow(dist,0.5)*5.0;
	float angle = atan(p.y,p.x)/PI/2.0;
	if (p.y<0.0) angle = atan(-p.y,-p.x)/PI/2.0+0.5;

	float brightness = ((cos((dist+angle*PI*4.0*blades)*0.5) + 2.0) /4.0);
	brightness += 1.0- length(p);

	return brightness;
}






void main(void)
{
	vec2 p = gl_FragCoord.xy/resolution.xy*2.0-1.0;
	p.x/=resolution.y/resolution.x;
	
	float sa = spiral(p, 2.0, 10.0, 4.0); 
	float sb = spiral(p, -2.0, 10.0, 8.0); 
	
	float r = mix(sa,sb,0.75);
	float g = sa*0.6*sb*0.85;
	float b = sa*0.1*sb*0.2;
	
	gl_FragColor = vec4( vec3(r,g,b),1.0);//smoothstep(0.0, dist, brightness));
}