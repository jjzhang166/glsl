#ifdef GL_ES
precision mediump float;
#endif
// dashxdr was here 20120228

// renamed some vars _knaut

#define PI 3.1415927
#define PI2 (PI*2.0)
#define IBALLRAD (1.0/.5)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float patternRes;
uniform float petalSize;
uniform float petalColorIntensity;
uniform float petalColorSpread;

uniform float red;
uniform float green;
uniform float blue;

uniform float lotusY;
uniform float lotusX;

float specularity = 1.0;

void main( void ) {
	
	float petalSize = 2.1;
	float patternRes = 0.04;
	float petalColorIntensity = 1.0;
	float petalColorSpread = 1.0;

	float red = .5;
	float green = .1;
	float blue = 1.0;
	
	float lotusY = 3.0;
	float lotusX = 4.0;

	float specularity = 1.0;
 
	vec2 position = ( 1.0*gl_FragCoord.xy - resolution/2.0) / resolution.xx;
 
	float adjust1 = mouse.x * 100.0;
	float adjust2 = mouse.y;
	adjust1 = 50.0;
	adjust2 = 1.0;

	position *= adjust1;
	float r = length(position);
	float fix = time;

	float a = atan(sin(position.y/ lotusX ), cos(position.y/ lotusY )) + PI;
	float q = cos(position.x);
	float p = sin(position.y);
	float d = r - a + PI2;
	
	int n = int(d/PI2);
	d = d - float(n)*PI2;
	
	float dd = 1.;
	a=a+q/d+p/d;
	
	float da = a+float(n)*PI2;
	vec3 norm;
	
	float pos = da*da* patternRes +fix;

	
	norm.xy = vec2(fract(pos) - d/ petalSize , d / 5.0 - .1)*IBALLRAD;
	float len = length(norm.yx);
	vec3 color = vec3(0.,0.0, .0);
	
	if(len <= 1.8)
	{
		norm.z = sqrt(petalColorIntensity -  len*len);
		vec3 lightdir = normalize(vec3(-3.0, 1.0, 50.0));
		dd = dot(lightdir, norm);
		dd = max(dd, .5);
		float rand = cos(floor(pos));
		
		// color pattern
		color.rgb = dd*fract(rand*vec3(red, green, blue));

		// specularity pattern
		vec3 halfv = normalize(lightdir + vec3( specularity, .2, 1.5));
		float spec = dot(halfv, norm);
		spec = max(spec, 0.970);
		spec = pow(spec, 70.0);
		color += spec*vec3(3.0, 1.0, 1.0);
	}
	
	gl_FragColor.rgba = vec4(color, 1.0);
 
}