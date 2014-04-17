#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define speed 0.025

/*
 * Basic tunnel effect.
 * Thanks to Adrian Boeing for his tutorial at http://adrianboeing.blogspot.com.ar/2011/01/webgl-tunnel-effect-explained.html
 * some modifications by epyx
 * further edits by Flexi23
 */

// Scale factor for blob fields
const float scale = 1.534212;

// Rotation matrix for blob fields (to make them appear less uniform). There's no magic behind this - it's just a random orthogonal matrix.
const mat3 dottransform = mat3(
0.11651722197701599,0.3544947103881083,0.9277700347012776,
-0.10673931989767256,-0.9242528744643419,0.3665560552387368,
0.9874363040574016,-0.14173963578072568,-0.06985285304270773
)*scale;

const int maxiter=11;

//

float meteor(vec3 pos)
{
	vec3 position = pos;
	
	// I create 3 sums here, 2 for craters, one for blobs.
	// For 2 of them I don't simply sum but sum squares and later take the square root. This is to suppress undesired accumulation of details.
	// You can observe the outcome at the craters: large craters suppress smaller ones. Similar things happen with blobs.
	// If you are curious you can remove the *abs(dots) part as well as the sqrt(craters) resp. sqrt(blobs) at the outcome.
	// Example:
	// * sqrt(0^2 (no big crater) + 0^2) (no small crater) = 0
	// * sqrt(4^2 (   big crater) + 0^2) (no small crater) = 5
	// * sqrt(0^2 (no big crater) + 1^2) (   small crater) = 1
	// * sqrt(4^2 (   big crater) + 1^2) (   small crater) = 4.12... (suppressed small crater)
	// Just 1 of the "crater" sums actually suppresses small craters. This is to reflect what happens on
	// real asteroids: big impacts destroy previous craters but new impacts still create additional craters.

	float craters = 0.0;
	float craters2 = 0.0;
	float blobs = 0.0;
	float f = .1;	// initial scale
	position *= f;
	for (int i = 0; i < maxiter; i++) {
		// This creates regularly spaced blobs, one per unit cell
		vec3 v = fract(position)-.5;		// distance vector from unit cell center
		float dots = max(0.,0.24-dot(v,v));	// simple blob around the unit cell center
		dots = dots*dots*dots/f;		// 3rd power to smooth out the border of the unit cell

		// Opposite sign for every other unit cell
		vec3 signv = sign(fract(position*.5)-.5);
		float signf = signv.x*signv.y*signv.z;

		// Add blobs to either of the sums, depending on sign. Note that I add the square of the blob.
		craters += max(0.,dots*signf)*abs(dots);
		craters2 += min(0.,dots*signf);
		blobs += min(0.,dots*signf)*abs(dots);
		
		// Rotate and scale the view (and thus the next series of blobs)
		f *= scale;
		position *= dottransform;
	}
	// Isosurface function. < 0 = inside blob, > 0 = in outer space. Ideally any value > 0 should be the distance to the nearest spot where the value is <= 0.
	return (craters2*1.0+sqrt(craters)-sqrt(-blobs))*55.1+1.;
}

const float fScale=38.5;

vec3 getColour(vec2 pos)
{
	float fBias=resolution.y/resolution.x;

	vec3 p1=(vec3(pos*fBias,0.0)*2.0-1.0)*fScale;
	vec3 p2=normalize(vec3(-0.5,-0.5,1.5));

	vec3 s=vec3(0.0,0.1,0.0);

	float s1=meteor(p1);
	float s2=meteor(p1+s.xyz);
	float s3=meteor(p1+s.yxz);

	vec3 n=normalize(vec3(s1,s2,s3));

	float fHalf=dot(p2,n);
	vec3 c=vec3((fHalf*0.5)+0.4);

	return c;
}

void main( void ) {

	// Normalize coords from 0->1 with 0.5, 0.5 at center.
	vec2 position = 2.0 * gl_FragCoord.xy / resolution.xy - 1.00;
	position.x += 2.0 * ( mouse.x - 0.5 );
	position.y += 2.0 * ( mouse.y - 0.5 );
	position.x *= resolution.x / resolution.y; // Correct aspect ratio.

	// Cartesian coords to polar coords.
	float a = atan( position.y, position.x );
	float r = exp(length( (position)* 2.5))*0.25;
	

	vec2 p = vec2( 0.1 / r + speed * time*2., ( a - ( sin(time*0.)*(speed/2.) ) * time ) / 3.1416 );
	vec3 c = getColour( p );
	
	// Use r to create a little distance fog.
	gl_FragColor = vec4( c, 1.0 );

}