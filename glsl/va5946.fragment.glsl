#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// based on http://de.wikipedia.org/w/index.php?title=Datei:Newton-lplane-Mandelbrot-smooth.jpg&filetimestamp=20081017234443

// converted to GLSL by Kabuto. Note that the colors are different as I didn't use HSL.

const int argd1 = 200;
const float argd4 = 3.;

vec2 Nf (vec2 z, out vec2 r2, vec2 lambda)
{
    // *r2 = z^3+(lambda-1)*z-lambda
    // return (2*z^3+lambda)/(3*z*z+lambda-1)
	
    vec2 z2 = vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
 
    vec2 f = z2 + lambda - vec2(1,0);
    r2 = vec2(f.x*z.x-f.y*z.y,f.x*z.y+f.y*z.x)-lambda;
 
    vec2 N = 3. * z2 + lambda - vec2(1,0);
 
    vec2 Z = vec2(z.x*z2.x-z.y*z2.y,z.x*z2.y+z.y*z2.x)*2.+lambda;
 
    return vec2(Z.x*N.x+Z.y*N.y,Z.y*N.x-Z.x*N.y)/dot(N,N);
}

vec3 getLambdaColor (float x, float y) {
    vec2 z = vec2(0);
    vec2 lambda =vec2(x,y);
 
    vec2 f;
    float eps = .001;
    float le = 1./log(eps);
	const float PI = 3.141592653589;
 
    for (int i=0; i < argd1; i++)
    {
        float v, s, h, b2;
        z = Nf(z, f, lambda);
 
        b2 = dot(f,f);
        if (b2 < eps*eps)
        {
            float b = 0.5*log(b2)*le;
            if (!(abs(b)<1e10)) b = 2.;
 
            b = float(i)-b;
            z = vec2(length(z),mod(atan(z.y,z.x),2.*PI));
            h = z.y/2./PI-.09;
 
            v = b / argd4;
            s = 0.9-0.7*pow(v, 1.5);
            if (v >= 1.)
            {
                float q = 1.-log (b-argd4)/log(float(argd1)-argd4);
                s = max(4.*q*(1.-q),0.);
                s = 0.2+0.6*pow(s, 10.);
                v = 1.;
            }
 
            return fract(vec3(h, s, v));
        }
    }
 
    return vec3(0);
}
 



void main( void ) {

	vec2 position = ( gl_FragCoord.xy - resolution*.5) / resolution.y;
	position = position*.11+vec2(.3,1.64);

	gl_FragColor = vec4( getLambdaColor(position.x,position.y), 1.0 );

}

