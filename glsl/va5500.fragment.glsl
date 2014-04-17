#ifdef GL_ES
precision mediump float;
#endif

// Some wave function experiments - kabuo

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float N = 71.;
const float PI = 3.14159265359;


// Converts complex number into nice colors, similar to what wikipedia articles about complex numbers use for their diagrams.
// 0 -> black, values on unit disc -> rainbow colors, infinity -> white
vec3 complexcolor(vec2 p){
	float pl = length(p);
	float amp = atan(pl)*2./3.14159265359;
	
	vec3 color = vec3(p.x,-p.x*.5-p.y*.86,-p.x*.5+p.y*.86)/pl;
		
	return vec3(amp)+color*amp*(1.-amp);
}

// Summed over all angles this should yield a nice gaussian bell curve.
// I didn't verify algebraically but this seems to do the trick.
float gf(float p){
	return exp(-p*p*.5)-1./(PI*.5+p*p);
}



void main( void ) {
	// Origin in the middle of the scren, 1 unit across horizontally (factor .50001 is to avoid render bugs
	// for functions with removable singularities such as sinc)
	vec2 pos = ( gl_FragCoord.xy - resolution.xy*.50001 ) / resolution.x;

	// Number of waves to add depends on mouse y position. This uses some math foo as WebGL does not permit changing
	// number of loop iterations (so if we just need 3 out of 71 iterations the remaining 68 ones are simply wasted.)
	float sum = 0.;
	float steps = floor(mouse.y*mouse.y*(N-1.))+1.;
	for (float a = 0.; a < N; a++) {

		// Spread iterations evenly across 0..PI. We need to cover just half the circle as the wave function is assumed to be symmetrical.
		float angle = a*PI/steps;
		vec2 dir = vec2(cos(angle),sin(angle));
		
		// Assuming a wave of infinite width. Okay so far? Now assume 2 waves of infinite width and opposite direction but equal distance to the center being added together.
		float p = dot(dir,pos)*100.; // Position within a single wae
		float pd = mouse.x*mouse.x*25.; // Distance the wave has travelled
		
		sum += (gf(p-pd)+gf(p+pd))*step(a,steps-.5);
		
	}
	sum /= steps;

	sum *= 2.;
	

	gl_FragColor = vec4(complexcolor(vec2(sum,0.)),1.);

}
