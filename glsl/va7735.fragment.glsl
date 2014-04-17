#ifdef GL_ES
precision mediump float;
#endif

#define MAX_ITER 32
#define PI 3.14159265358969

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 divide(vec2 a, vec2 b){
	return vec2(a.x * b.x + a.y * b.y, (a.y * b.x - a.x * b.y)) / dot(b, b);
}

vec2 toComplex(mat2 matrix){
	return vec2(matrix[0][0], matrix[0][1]);
}

mat2 toMatrix(vec2 complex){
	return mat2(complex.x, complex.y, -complex.y, complex.x);
}

vec2 evaluateFunction(mat2 x){
	return toComplex(x*x*x*x*x*x*x) + 15.0 * toComplex(x*x*x*x) + 3.0;
	//return toComplex(x*x*x) - vec2(1.0, 0.0);
	//return toComplex(x*x) - vec2(1.0, 0.0);
}

vec2 evaluateDerivative(mat2 x){
	return 7.0 * toComplex(x*x*x*x*x*x) + 60.0 * toComplex(x*x*x) + 3.0;
	//return 3.0 * toComplex(x*x);
	//return 2.0 / toComplex(x);
}

vec2 root_newton(vec2 guess){
	for (int i = 0; i < MAX_ITER; i++){
		mat2 theMatrix = toMatrix(guess);
		guess = guess - divide(evaluateFunction(theMatrix), evaluateDerivative(theMatrix));
	}
	return guess;
}

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy - mouse / 4.0) - vec2(.5, .5));
	
	vec2 root = root_newton(position);
	float arg = atan(root.x, root.y);// + PI / 2.0;

	gl_FragColor = //vec4((cos(arg) + 1.0) / 2.0, (sin(arg) + 1.0) / 2.0, 0.0, 1.0);
		vec4(sin(arg), sin(arg + 2.0 * PI / 3.0), sin(arg + 4.0 * PI / 3.0), 1.0);

}