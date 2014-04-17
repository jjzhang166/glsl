/*
 * A scene from 'Den Tredje Bart' by Carl B (http://www.pouet.net/prod.php?which=54115)
 * Code by Kusma
 * Requires GL_OES_standard_derivatives to look good, but Google Chrome doesn't seem
 * to support it. Oh well.
 *
 * Any kind of mouse control and/or time-based animation seems to make ANGLE cry, so
 * I've removed it for now.
 */

/*
	No angle to suffer here, so I put some time-based animation in. Sorry if it 
	makes your machine cry Kusma :D
	I should make the end balls follow an arc. But I should sleep too. Sleep wins.
	- psonice
*/

#ifdef GL_ES
precision mediump float;
#endif

#ifdef GL_OES_standard_derivatives
#extension GL_OES_standard_derivatives : enable
#else
/* ANGLE seems to barf on smoothstep(x, x+0.0, y) :( */
#define fwidth(x) vec2(0.0001)
#endif

uniform vec2 resolution;
uniform float time;

const vec3 skyBottomColor = vec3(0.3, 0.4, 0.8) * 1.75;

vec3 environment(vec3 dir)
{
	vec3 bg = mix(
		skyBottomColor,
		vec3(0.3, 0.35, 0.8) * 0.8,
		pow(max(0.0, dir.y), 0.6));
	return bg + pow(max(0.0, dot(dir, normalize(vec3(1.0, 2.0, 0.0)))), 100.0) * vec3(2.5, 3.0, 0.0) * 0.5;
}

float traceSphere(vec3 pos, vec3 dir, vec3 spos, float rr)
{
	vec3 dst = pos - spos;
	float a = dot(dst, dst);
	float b = dot(dst, dir);
	float c = a - rr;
	float d = b * b - c;

	if (d > 0.0)
		return -b - sqrt(d);
	else
		return -1.0;
}

vec4 trace(vec3 pos, vec3 dir)
{
#define SPHERES 5
	vec3 spos[SPHERES];
	for (int i = 0; i < SPHERES; ++i) {
		float th = float(i) * (2.0 * 3.14159265 / float(SPHERES));
		//spos[i] = vec3(sin(th + (time * .34))* 4., 0.0, cos(th + (time*.55)) * 4.);
		spos[i] = vec3(float(i*2) - 4., 0., 0.);
		if(i==0){
			spos[i] += vec3(min(sin(time*2.), 0.), -min(sin(time*2.), 0.), 0.);	
		}
		if(i==SPHERES -1){
			spos[i] += vec3(max(sin(time*2.), 0.), max(sin(time*2.), 0.), 0.);
		}
	}

	float mint = 999999.0;
	vec4 sphereHit = vec4(0.0);
	for (int i = 0; i < SPHERES; ++i) {
		float t = traceSphere(pos, dir, spos[i], 1.0);
		if (t > 0.0 && t < mint) {
			sphereHit = vec4(spos[i], 1.0);
			mint = t;
		}
	}

	float totalt = 0.0;
	if (sphereHit.w > 0.0) {
		pos += dir * mint;
		totalt += mint;
		vec3 n = pos - sphereHit.xyz;
		dir = reflect(dir, n);

		for (int i = 0; i < 4; ++i) {
			mint = 999999.0;
			vec4 newSphereHit = vec4(0.0);
			for (int j = 0; j < SPHERES; ++j) {
				if (spos[j] == sphereHit.xyz)
					continue;

				float t = traceSphere(pos, dir, spos[j], 1.0);
				if (t > 0.0 && t < mint) {
					newSphereHit = vec4(spos[j], 1.0);
					mint = t;
				}
			}
   
			if (newSphereHit.w <= 0.0)
				break;

			pos += dir * mint;
			totalt += mint;
			sphereHit = newSphereHit;
			vec3 n = pos - sphereHit.xyz;
			dir = reflect(dir, n);
		}
	}

	float dist = 1.0;
	float t = -(pos.y + dist) / dir.y;
	vec2 fw = fwidth(pos.xz + dir.xz * t);
 
	if (dir.y < 0.0 && t > 0.0) {
		pos += dir * t;
		totalt += t;
	      	vec2 fuzz = fw * 2.0;
		float fuzzMax = max(fw.x, fw.y);
		vec2 checkPos = fract(pos.xz + fuzz * 0.5);
	      	vec2 pp = 
		 	smoothstep(vec2(0.5), vec2(0.5) + fuzz, checkPos) +
			(1.0 - smoothstep(vec2(0.0), fuzz, checkPos));
	      	float p = pp.x * pp.y + (1.0 - pp.x) * (1.0 - pp.y);
		p = mix(p, 0.5, smoothstep(0.125, 0.5, fuzzMax));

	      	vec3 n = vec3(0.0, 1.0, 0.0);
		float ao = 2.;
		for (int i = 0; i < SPHERES; ++i) {
			ao -= max(
				0.0, -normalize(pos - spos[i]).y) *
				pow(1.0 / distance(pos, spos[i]), 2.
			      ) * ao;
	      	}
	     	p *= ao * ao * ao;
	     	vec3 c = mix(skyBottomColor, vec3(p,p,p), 1.0 / max(1.0, 0.75 + totalt * 0.035));
		return vec4(c, 1.0);
	} else 
		return vec4(environment(dir), 1.0);
}

void main(void)
{
	vec3 pos = vec3(0.0, 3.0, 10.0);
	vec3 dir = normalize(vec3((gl_FragCoord.xy - resolution.xx * 0.5) / resolution.yy, -1.0));
	gl_FragColor = sqrt(trace(pos, dir)); /* fake sRGB conversion; assumes a gamma of 2.0 */
}