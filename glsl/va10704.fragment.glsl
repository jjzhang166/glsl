#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float k = 100.0;
float f = 0.0;
float threshold = 10.0;

vec3 colour = vec3(0.0,0.0,0.0);
vec3 normal = vec3(0.0,0.0,0.0);

vec3 lightPos = vec3(resolution.xy,2000.0);
vec3 lightColour = vec3(0.9,0.9,1.0);
vec3 ambient = vec3(0.1,0.0,0.0);
float shinyness = 20.0;
float diffuseFactor = 0.0006;

vec2 center ( vec2 border , vec2 offset , vec2 vel ) {
	vec2 c = offset + vel * time * 0.5;
	c = mod ( c , 2. - 4. * border );
	if ( c.x > 1. - border.x ) c.x = 2. - c.x - 2. * border.x;
	if ( c.x < border.x ) c.x = 2. * border.x - c.x;
	if ( c.y > 1. - border.y ) c.y = 2. - c.y - 2. * border.y;
	if ( c.y < border.y ) c.y = 2. * border.y - c.y;
	//c.x += 0.001 * sin(gl_FragCoord.x/5.0);
	//c.y += 0.001 * cos(gl_FragCoord.y/5.0);
	return c;
}

float field ( float b, float r ) {
	if ( r > b )
		return 0.0;
	if ( r >= b/3.0 ) {
		float rb = 1.0 - r/b;
		return (3.0*k)/2.0 * rb * rb;
	}
	if ( r >= 0.0 && r <= b/3.0 ) {
		return k * ( 1.0 - ( (3.0*r*r)/(b*b) ) );	
	}
	return 0.0;
}

void circle ( float r , vec3 col , vec2 offset , vec2 vel ) {
	vec2 pos = gl_FragCoord.xy / resolution.y;
	float aspect = resolution.x / resolution.y;
	vec2 c = center ( vec2 ( r / aspect , r ) , offset , vel );
	c.x *= aspect;
	float d = distance ( pos , c );
	float thisField = field (r, d);
	f += thisField;
	colour += col * thisField;
	normal += normalize(vec3(pos.x-c.x, pos.y-c.y,r))*thisField;
}
	
void main( void ) {

	circle ( .10 , vec3 ( 0.7 , 0.2 , 0.8 ) , vec2 ( .6 ) , vec2 ( .30 , .70 ) );
	circle ( .09 , vec3 ( 0.7 , 0.9 , 0.6 ) , vec2 ( .1 ) , vec2 ( .02 , .20 ) );
	circle ( .12 , vec3 ( 0.3 , 0.4 , 0.1 ) , vec2 ( .1 ) , vec2 ( .10 , .04 ) );
	circle ( .15 , vec3 ( 0.2 , 0.5 , 0.1 ) , vec2 ( .3 ) , vec2 ( .10 , .20 ) );
	circle ( .20 , vec3 ( 0.1 , 0.3 , 0.7 ) , vec2 ( .2 ) , vec2 ( .40 , .25 ) );
	circle ( .30 , vec3 ( 0.9 , 0.4 , 0.2 ) , vec2 ( .0 ) , vec2 ( .15 , .20 ) );
	
	vec3 c;
	
	if (f < threshold)
		c = vec3(0.0,0.0,0.0);
	else {
		colour /= f;
		normal = normal/f;
		
		c = ambient;
		vec3 lightDir = lightPos - vec3(gl_FragCoord.xy,0.0);
		c += colour * diffuseFactor * max(dot(normal,lightDir), 0.0);
		vec3 r = normalize ( reflect ( lightDir, normal ) );
		c += lightColour * pow(max(dot(r,vec3(0.0,0.0,-1.0)), 0.0), shinyness);	
	}
	
	gl_FragColor = vec4( c, 1.0 );
}