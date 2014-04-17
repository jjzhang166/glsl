	#ifdef GL_ES
	precision mediump float;
	#endif

	uniform float time;
	uniform vec2 mouse;
	uniform vec2 resolution;

	const int raytraceDepth = 8;

	struct Ray
	{
		vec3 org;
		vec3 dir;
	};
	struct Sphere
	{
		vec3 c;
		float r;
		vec3 col;
	};

	struct Plane
	{
		vec3 p;
		vec3 n;
		vec3 col;
	};

	struct Intersection
	{
		float t;
		vec3 p;     // hit point
		vec3 n;     // normal
		int hit;
		vec3 col;
	};

	void shpere_intersect(Sphere s,  Ray ray, inout Intersection isect)
	{
		// rs = ray.org - sphere.c
		vec3 rs = ray.org - s.c;
		float B = dot(rs, ray.dir);
		float C = dot(rs, rs) - (s.r * s.r);
		float D = B * B - C;

		if (D > 0.0)
		{
			float t = -B - sqrt(D);
			if ( (t > 0.0) && (t < isect.t) )
			{
				isect.t = t;
				isect.hit = 1;

				// calculate normal.
				vec3 p = vec3(ray.org.x + ray.dir.x * t,
						  ray.org.y + ray.dir.y * t,
						  ray.org.z + ray.dir.z * t);
				vec3 n = p - s.c;
				n = normalize(n);
				isect.n = n;
				isect.p = p;
				isect.col = s.col;
			}
		}
	}

	void plane_intersect(Plane pl, Ray ray, inout Intersection isect)
	{
		float d = -dot(pl.p, pl.n);
		float v = dot(ray.dir, pl.n);

		if (abs(v) < 1.0e-6)
			return; // the plane is parallel to the ray.

		float t = -(dot(ray.org, pl.n) + d) / v;

		if ( (t > 0.0) && (t < isect.t) )
		{
			isect.hit = 1;
			isect.t   = t;
			isect.n   = pl.n;

			vec3 p = vec3(ray.org.x + t * ray.dir.x,
				  ray.org.y + t * ray.dir.y,
				  ray.org.z + t * ray.dir.z);
			isect.p = p;
			float offset = 0.2;
			vec3 dp = p + offset;
			if ((mod(dp.x, 1.0) > 0.5 && mod(dp.z, 1.0) > 0.5)
			||  (mod(dp.x, 1.0) < 0.5 && mod(dp.z, 1.0) < 0.5))
				isect.col = pl.col;
			else
				isect.col = pl.col * 0.5;
		}
	}

	Sphere sphere[4];
	Plane plane;

	void Intersect(Ray r, inout Intersection i)
	{
		shpere_intersect(sphere[0], r, i);
		shpere_intersect(sphere[1], r, i);
		shpere_intersect(sphere[2], r, i);
		shpere_intersect(sphere[3], r, i);

		plane_intersect(plane, r, i);
	}

	float halfLambert(in vec3 vect1, in vec3 vect2)
	{
		float product = dot(vect1,vect2);
		return product * 0.5 + 0.5;
	}

	float blinnPhongSpecular(in vec3 normalVec, in vec3 lightVec, in float specPower)
	{
		vec3 halfAngle = normalize(normalVec + lightVec);
		return pow(clamp(0.0,1.0,dot(normalVec,halfAngle)),specPower);
	}

	vec4 subScatterFS(in Intersection isect)
	{

		float eps  = 0.0001;
		float RimScalar = 0.05;
		float MaterialThickness = 0.5;
		vec3 ExtinctionCoefficient = vec3(0.1,0.1,0.1);
		vec3 SpecColor = vec3(0.5,0.5,0.5);
		vec3 lightPoint = vec3(5,5,5);

		// Slightly move ray org towards ray dir to avoid numerical probrem.
		vec3 p = vec3(isect.p.x + eps * isect.n.x,
			isect.p.y + eps * isect.n.y,
			isect.p.z + eps * isect.n.z);

		float attenuation = 10.0 * (1.0 / distance(lightPoint,isect.p));
		vec3 eVec = normalize(isect.p);
		vec3 lVec = normalize(lightPoint - p);
		vec3 wNorm = normalize(isect.n);

		vec3 dotLN = vec3(halfLambert(lVec,wNorm) * attenuation);
		dotLN *= isect.col;
		
		vec3 indirectLightComponent = vec3(MaterialThickness * max(0.0,dot(-wNorm,lVec)));
		indirectLightComponent += MaterialThickness * halfLambert(-eVec,lVec);
		indirectLightComponent *= attenuation;
		indirectLightComponent.r *= ExtinctionCoefficient.r;
		indirectLightComponent.g *= ExtinctionCoefficient.g;
		indirectLightComponent.b *= ExtinctionCoefficient.b;

		vec3 rim = vec3(1.0 - max(0.0,dot(wNorm,eVec)));
		rim *= rim;
		rim *= max(0.0,dot(wNorm,lVec)) * SpecColor.rgb;
		
		vec4 finalCol = vec4(dotLN,1.0) + vec4(indirectLightComponent,1.0);
		finalCol.rgb += (rim * RimScalar * attenuation * finalCol.a);
		finalCol.rgb += vec3(blinnPhongSpecular(wNorm,lVec,5.0) * attenuation * SpecColor * finalCol.a * 0.05);
		finalCol.rgb *= vec3(1,1,1);

		return finalCol;   
	}

	void main( void ) {

		vec2 position = ( gl_FragCoord.xy / resolution.xy );
		position -= vec2( 0.5,0.5 );
		position.x *= 2.0;

		//asdf
		float ss = sin(time*0.3);
		float cc = cos(time*0.3);
		vec3 org = vec3(ss*4.0,0,cc*4.0);
		vec3 dir = normalize(vec3(position.x*cc-ss,position.y, -position.x*ss-cc));

		sphere[0].c   = vec3(-2.0, 0.0+sin(time)*.5+0.5, -1.0);
		sphere[0].r   = 0.5;
		sphere[0].col = vec3(1,0.3,0.3);
		sphere[1].c   = vec3(sin(time+3.14)*1.5-0.5, 0.0, -1.0);
		sphere[1].r   = 0.5;
		sphere[1].col = vec3(0.3,1,0.3);
		sphere[2].c   = vec3(1.0, sin(time+3.14)*.5*0.5, 0.0);
		sphere[2].r   = 0.5;
		sphere[2].col = vec3(0.43,0.3,1);
		sphere[3].c   = vec3(-2.0, sin(time+3.14)*.5+0.5, -1.50);
		sphere[3].r   = 0.5;
		sphere[3].col = vec3(0.8,0.3,1);
		plane.p = vec3(0,-0.5, 0);
		plane.n = vec3(0, 1.0, 0);
		plane.col = vec3(1,1, 1);

		Ray r;
		r.org = org;
		r.dir = normalize(dir);
		vec4 col = vec4(0,0,0,1);
		float eps  = 0.0001;
		vec3 bcol = vec3(1,1,1);
		for (int j = 0; j < raytraceDepth; j++)
		{
			Intersection i;
			i.hit = 0;
			i.t = 1.0e+30;
			i.n = i.p = i.col = vec3(0, 0, 0);

			Intersect(r, i);
			if (i.hit != 0)	{
				col = subScatterFS(i);
			}else{
				break;
			}
		}
		gl_FragColor = col;


	}