#ifdef GL_ES
precision mediump float;
#endif
/* A 2D attempt to calculate noise using derivatives
 *-jbernard
 *
 * http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
*/

uniform float time;
uniform vec2 resolution;

float rand(float x, float y){
	return fract(sin((x+y*1e3)*1e-3) * 1e5);
}

void noise(float x, float y, out float n[3]){
	float i, j;
	float u, v;
	
	i = floor(x); j = floor(y);
	u = fract(x); v = fract(y);
	
	float du = 30.0*u*u*(u*(u-2.0)+1.0);
	float dv = 30.0*v*v*(v*(v-2.0)+1.0);

    	u = u*u*u*(u*(u*6.0-15.0)+10.0);
    	v = v*v*v*(v*(v*6.0-15.0)+10.0);
	
	float a = rand( i+0.0, j+0.0);
	float b = rand( i+1.0, j+0.0);
	float c = rand( i+0.0, j+1.0);
	float d = rand( i+1.0, j+1.0);
	
	float k0 = a;
    	float k1 = b - a;
    	float k2 = c - a;
    	float k3 = a - b - c + d;

	n[0] = k0 + k1*u + k2*v + k3*u*v;
 	n[1] = du * (k1 + k3*v);
    	n[2] = dv * (k2 + k3*u);
}

void main(void)
{	
	
	vec2 p = (gl_FragCoord.xy) / resolution.xy * 10.0  ;
	float f = 0.0;
    	float w = 0.5;
    	float dx = 0.0;
    	float dz = 0.0;

    	for( int i=0; i < 8; i++ )
    	{
		float n[3];
		noise( p.x, p.y, n );
		dx += n[1];
		dz += n[2];
		f += w * n[0] / (1.0 + dx*dx + dz*dz); // replace with "w * n[0]" for a classic fbm()
		w *= 0.5;
		p.x *= 2.0;
		p.y *= 2.0;
    	}
	
	gl_FragColor = vec4(f, f, f, 1.0);
}