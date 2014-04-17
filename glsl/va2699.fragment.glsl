// a simple sphere raytracer for educational purposes
// hellfire/haujobb

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

// position and radius of the 3 spheres
vec4 sphere[3];

// colors of the 3 spheres
vec3 colors[3];
		  
// position and color of the light sources
vec3 lightpos[3];
vec3 lightcol[3];

// absolute threshold. anything beyond this distance will be discarded
const float THRES= 1000.0;

// if a sphere is hit remember the position, normal and sphere
vec3 hitposition;
vec3 hitnormal;
vec3 hitcolor;

// reflect direction vector "dir" at "normal"
vec3 reflection(vec3 dir, vec3 normal)
{
	return reflect(normalize(dir), normal);
  dir= normalize(dir);
  return dir - normal * 2.0 * dot(normal, dir);
}

// intersect sphere with ray o+t*d
// discard hits with t>thres (a closer hit already exists)
float intersectSphere(vec3 o, vec3 d, vec4 sphere, vec3 color, float thres)
{
   vec3 l= sphere.xyz - o;
   float tca= dot(l, d);
   // sphere is behind the ray: intersection is impossible
   if (tca < 0.0)
      return thres;
   
   // project center onto ray
   float d2= dot(l,l) - tca*tca;
   
   // distance is longer than radius: no intersection
   if (d2 > sphere.w*sphere.w)
      return thres;
   float thc= sqrt(sphere.w*sphere.w - d2);
   float t0= tca - thc;
   
   // intersection is further away than current threshold: skip
   if (t0 > thres)
      return thres;

   // get intersection position, surface normal and sphere color
   hitposition= o + t0*d;
   hitnormal= normalize(hitposition - sphere.xyz); //  / sphere.w
   hitcolor= color;

   return t0;
}

// find the nearest intersection point of the ray with the scene
float intersectScene(vec3 p, vec3 d)
{
   float t= THRES;
   
   for (int i=0;i<3;i++)
      t= intersectSphere(p, d, sphere[i], colors[i], t);
	
   return t;
}

// is anything between the points "src" (point on surface) and "dst" (light source) ?
bool rayBlocked(vec3 src, vec3 dst)
{
   vec3 dir= dst - src;
   float length= sqrt( dot(dir,dir) );
   dir = dir / length;
   float t= intersectScene(src + dir*0.001, -dir);
   if (t > 0.0 && t < length)
      return true;
   else
      return false;
}

// Additions by Yours3!f
vec3 calcLight(vec3 lpos, vec3 lcol, vec3 pos, vec3 normal, vec3 col)
{
      vec3 color= vec3(0.0, 0.0, 0.0);
	
      // no lighting if point is shadowed
      if (!rayBlocked(pos, lpos))
      {
	  // get light direction and distance
	  vec3 l = normalize( pos - lpos );
	  vec3 n = normal;
	      
	  float n_dot_l = dot( n, l );
	      
	  if( n_dot_l > 0.0 )
	  {
		vec3 epsilon = vec3( 1.0, 0.0, 0.0 ); // global tangent direction
		vec2 aniso_roughness = vec2( 0.4, 0.2 ) + vec2( 0.00001, 0.00001 );
		float iso_roughness = 0.2;
		float roughness_sq = iso_roughness * iso_roughness + 0.00001;
		float shininess = 30.0;
		  
		vec3 v = normalize( -pos );
		vec3 h = normalize( l + v );
		vec3 r = normalize( 2.0 * n * n_dot_l - l );
		vec3 t = normalize( cross( n, epsilon ) );
		vec3 b = normalize( cross( n, t ) );
		  
		float n_dot_v = dot( n, v );
		float n_dot_h = dot( n, h );
		float h_dot_t = dot( h, t );
		float h_dot_b = dot( h, b );
		float r_dot_v = dot( r, v );
		float h_dot_v = dot( h, v );
		
		vec3 diffuse_term = lcol * col;
		vec3 specular_term = lcol;
		
		vec3 specular = vec3( 0.0 );
		  
		if( n_dot_v > 0.0 )
		{	
			float beta = 0.0;
			float denom = 0.0;
			float numer = 0.0;
			
			// Ward anisotropic
			/**/
			vec2 beta_coeff = vec2( h_dot_t, h_dot_b ) / aniso_roughness;
			beta = -2.0 * dot( beta_coeff, beta_coeff ) / ( 1.0 + n_dot_h );
			
			denom = 3.14159 * aniso_roughness.x * aniso_roughness.x;
			numer = exp( beta );
			/**/
			
			// Ward isotropic
			/**
			beta = -pow( tan( acos( n_dot_h ) ), 2.0 );
			
			denom = 3.14159 * roughness_sq;
			numer = exp( beta / roughness_sq );
			/**/
			
			// Ward 1992
			/**
			denom *= 4.0 * sqrt( n_dot_l * n_dot_v );
			/**/
			
			// Ward-Dür 2006
			/**
			denom *= 4.0 * n_dot_l * n_dot_v;
			/**/
			
			// Ward-Moroder 2010
			/**/
			denom *= pow( n_dot_l + n_dot_v, 4.0 );
			float coeff_1 = dot( -b, l ) * dot( b, v );
			float coeff_2 = n_dot_l * n_dot_v;
			numer *= 2.0 * ( 1.0 + coeff_2 + coeff_1 * ( coeff_2 + coeff_1 ) );
			/**/
			
			specular = n_dot_l * specular_term * ( numer / denom );
		}		  
		
		// Phong 1973
		/**
		specular = specular_term * pow( max( r_dot_v, 0.0 ), shininess ); 
		/**/
		  
		// Blinn-Phong 1977
		/**
		specular = specular_term * pow( max( n_dot_h, 0.0 ), shininess );  
		/**/
		  
		// Cook-Torrance 1982
		/**
		float geo_numer = 2.0 * n_dot_h;
		float geo_denom = 1.0 / h_dot_v;
		
		float geo_b = ( geo_numer * n_dot_v ) * geo_numer;
		float geo_c = ( geo_denom * n_dot_l ) * geo_denom;
		float geo = min( 1.0, min( geo_b, geo_c ) );

		// Beckmann roughness
		float roughness_a = 1.0 / ( 4.0 * roughness_sq * pow( n_dot_h, 4.0 ) );
		float roughness_b = n_dot_h * n_dot_h - 1.0;
		float roughness_c = roughness_sq * n_dot_h * n_dot_h;
		float roughness = roughness_a * exp( roughness_b / roughness_c );
		  
		// Schlick fresnel 
		float f = pow( 1.0 - h_dot_v, 5.0 );
		
		specular = mix( specular_term, vec3( 1.0 ), f ) * ( geo * roughness ) / n_dot_v;
		/**/
		  
		color = n_dot_l * diffuse_term + specular;
	  }  
      }

      return color;
}

// calculate lighting for point "pos" with "normal" and color
vec3 calcLights(vec3 pos, vec3 normal, vec3 col)
{
   
   vec3 color= vec3(0.0, 0.0, 0.0);

   
   // iterate through all lights
	
   color += calcLight(lightpos[0], lightcol[0], pos, normal, col);
   color += calcLight(lightpos[1], lightcol[1], pos, normal, col);
   color += calcLight(lightpos[2], lightcol[2], pos, normal, col);
	
   return color;
}

// 
vec3 traceRay(vec3 p, vec3 d)
{
   int it= 0;
   vec3 color= vec3(0.0, 0.0, 0.0);
   vec3 origin= vec3(0.0, 0.0, 0.0);
   
   float scale= 1.0;
   
   // two iterations of reflection
   {
        float t= 0.0;
	t= intersectScene(p, d);
	if (t < THRES)
	{
		// ray intersects something
		// remember current hit information as calcLight will overwrite
		p= hitposition;
		vec3 nrm= hitnormal;
		
		// calculate lighting for this point
		color += calcLights(p, nrm, hitcolor) * scale;
		it++;
		
		
		// each iteration of reflection gets darker
		scale*=0.4;
		 
		// start new ray from intersection point along reflection vector
		d= reflection(p-origin, nrm);
		p+=d*0.01;
		origin= p;
		

		// reflection
		t= intersectScene(p, d);
		if (t < THRES)
		{
			 // ray intersects something
			 // remember current hit information as calcLight will overwrite
			 p= hitposition;
			 vec3 nrm= hitnormal;
			
			 // calculate lighting for this point
			 color += calcLights(p, nrm, hitcolor) * scale;
			
			 // each iteration of reflection gets darker
			 scale*=0.4;
			 
			 // start new ray from intersection point along reflection vector
			 d= reflection(p-origin, nrm);
			 p+=d*0.001;
			 origin= p;
			
			it++;
			
			// interreflection
			t= intersectScene(p, d);
			if (t < THRES)
			{
				 // ray intersects something
				 // remember current hit information as calcLight will overwrite
				 p= hitposition;
				 vec3 nrm= hitnormal;
				
				 // calculate lighting for this point
				 color += calcLights(p, nrm, hitcolor) * scale;
				
				 // each iteration of reflection gets darker
				 scale*=0.4;
				 
				 // start new ray from intersection point along reflection vector
				 d= reflection(p-origin, nrm);
				 p+=d*0.001;
				 origin= p;
				
				it++;
			}			
		}
	}
   }	

   if (it==0) // nothing hit: background gradient
     color= vec3(0.2, 0.2, 0.2) * (p.y+1.5);
   
   return color;
}


void main(void)
{
   float aspect= resolution.x / resolution.y;
   vec3 p= vec3(
	   (gl_FragCoord.x*2.0/resolution.x-1.0)*aspect,
	   (gl_FragCoord.y*2.0/resolution.y-1.0),
	   -1.0 );
   vec3 d= normalize(p);

   sphere[0]= vec4( sin(time*1.1),  cos(time*0.9),  -3.0+sin(time*0.8),  0.7);
   sphere[1]= vec4( cos(time*0.8), -sin(time*1.2),  -3.0+cos(time*0.9),  0.8);
   sphere[2]= vec4(-cos(time*1.3),  sin(time*0.7),  -3.0-cos(time*1.0),  0.9);

   colors[0]= vec3(0.9, 0.1, 0.1);
   colors[1]= vec3(0.9, 0.1, 0.1);
   colors[2]= vec3(0.9, 0.1, 0.1);

   lightpos[0]= vec3(-10.0, -5.0, -10.0);
   lightcol[0]= vec3(1.1, 0.8, 0.4);

   lightpos[1]= vec3( 5.0,  -3.0, -5.0); 
   lightcol[1]= vec3(0.6, 0.3, 1.1);

   lightpos[2]= vec3( -5.0,  3.0, -5.0); 
   lightcol[2]= vec3( 0.9, 0.6, 0.2 );
	
   // trace the ray and get rgb color
	// Twist that source ray
	vec3 p1;
	float tw = time+p.y*5.;
	p1.x = sin(tw)*p.x + cos(tw)*p.z;
	p1.y = p.y;
	p1.z = -sin(tw)*p.z + cos(tw)*p.x;
	vec3 color= traceRay(p1, d);

   gl_FragColor=vec4(color,1); //background color
}
