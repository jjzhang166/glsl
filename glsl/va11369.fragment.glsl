#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float MinReal = -2.0;
float MaxReal = 1.0;
float MinIm = -1.2;
float MaxIm = MinIm+(MaxReal-MinReal)* resolution.x/resolution.y;

int maxIter = 1000;

vec2 c_mult(vec2 a, vec2 b);
int mandel(float i, float j);

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec4 colorVal;
	
	if (mandel(position.x, position.y) == 1000){
		colorVal = vec4(0.0);
	}
	else {
		colorVal = vec4(1.0);
	}

	gl_FragColor = colorVal;

}

vec2 c_mult(vec2 a, vec2 b) {
  return vec2(a.x * b.x - a.y * b.y,
              (a.x+a.y)*(b.x+b.y) - a.x*b.x - a.y*b.y);
}

int mandel(int i, int j) {
	float c_real = MinReal + float(i)*(MaxReal-MinReal) / (resolution.x - float(1));
	float c_image = MaxIm - float(j)*(MaxIm-MinIm)/(resolution.y-float(1));
	
	vec2 c = vec2(c_real, c_image);
	vec2 z = vec2(0.0, 0.0);
	
	for(int h = 0; h < 1000; h++) {
		if (dot(z,z) < 4.0) {
			z = c_mult(z, z) + c;
		}
		else {
			return h;
		}
	}
	
	return maxIter;
}