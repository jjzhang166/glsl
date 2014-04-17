#ifdef GL_ES
precision mediump float;
#endif
/* A 2D attempt to calculate noise using derivatives
 *-jbernard -strepto
 *
 * http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
*/

uniform float time;
uniform vec2 resolution;

float rand(float x, float y){
	return fract(sin((x+y*1e3)*1e-3) * 1e5);
}

void noise(vec2 p, out vec3 n){
	vec2 i, u, du;
	
	i = floor(p);
	u = p-i;
	
	du = 30.0*u*u*(u*(u-2.0)+1.0);

    	u = u*u*u*(u*(u*6.0-15.0)+10.0);
	
	float a = rand( i.x+0.0, i.y+0.0);
	float b = rand( i.x+1.0, i.y+0.0);
	float c = rand( i.x+0.0, i.y+1.0);
	float d = rand( i.x+1.0, i.y+1.0);
	
	float k0 = a;
    	float k1 = b - a;
    	float k2 = c - a;
    	float k3 = a - b - c + d;

	n.x = k0 + k1*u.x + k2*u.y + k3*u.x*u.y;
 	n.y = du.x * (k1 + k3*u.y);
    	n.z = du.y * (k2 + k3*u.x);
}

void main(void)
{	
	vec2 p = (gl_FragCoord.xy) / resolution.xy * 10.0;
	float f = 0.0;
    	float w = 0.5;
    	vec2 d = vec2(0);
	
    	for( int i=0; i < 8; i++ )
    	{
		vec3 n;
		noise( p, n );
		d += n.yz;
		f += w * n.x / (1.0 + dot(d,d)); // replace with "w * n[0]" for a classic fbm()
		w *= 0.5;
		p *= 2.0;
    	}
	
	gl_FragColor = vec4(f, f, f, 1.0);
}