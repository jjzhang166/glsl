// a simple sphere raytracer for educational purposes
// hellfire/haujobb

// added a 4th ball and BALLS define. Squished text a bit. -db
// lights are just white from single direction now, specular shows black.

#ifdef GL_ES
precision highp float;
#endif
#define BALLS 4

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

vec4 sphere[BALLS]; // position and radius of the 3 spheres
vec3 colors[BALLS]; // colors of the 3 spheres
		  
vec3 lightpos[2]; // position and color of the light sources
vec3 lightcol[2];

const float THRES= 1000.0; // absolute threshold. anything beyond this distance will be discarded

vec3 hitposition; // if a sphere is hit remember the position, normal and sphere

vec3 hitnormal;
vec3 hitcolor;


vec3 reflection(vec3 dir, vec3 normal) // reflect direction vector "dir" at "normal"
{
  dir= normalize(dir);
  return dir - normal * dot(normal, dir); // 
}

// intersect sphere with ray o+t*d; discard hits with t>thres (a closer hit already exists)
float intersectSphere(vec3 o, vec3 d, vec4 sphere, vec3 color, float thres)
{
   vec3 l= sphere.xyz - o;
   float tca= dot(l, d);
   if (tca < 0.0) {  return thres; }    // sphere is behind the ray: intersection is impossible   
   float d2= dot(l,l) - tca*tca;    // project center onto ray
   
   if (d2 > sphere.w*sphere.w) { return thres; }    // distance is longer than radius: no intersection
   float thc= sqrt(sphere.w*sphere.w - d2);
   float t0= tca - thc;
   
   if (t0 > thres) { return thres; } // intersection is further away than current threshold: skip

   hitposition= o + t0*d; // get intersection position, surface normal and sphere color
   hitnormal= normalize(hitposition - sphere.xyz); //  / sphere.w
   hitcolor= color;

   return t0;
}

// find the nearest intersection point of the ray with the scene
float intersectScene(vec3 p, vec3 d)
{
   float t= THRES;
   for (int i=0;i< BALLS; i++)
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


vec3 calcLight(vec3 lpos, vec3 lcol, vec3 pos, vec3 normal, vec3 col)
{
      vec3 color= vec3(0.0, 0.0, 0.0);
	
      // no lighting if point is shadowed
      if (!rayBlocked(pos, lpos))
      {
	  // get light direction and distance
	  vec3 dir= (pos - lpos);
	  float invDist= 1.0 / sqrt( dot(dir,dir) );
	  dir= dir*invDist; // normalize

	  // diffuse: light -> surface
	  float diffuse= dot(dir, normal);
	  if (diffuse > 0.0)
	  {
	    color += col * diffuse * lcol * invDist * 15.0;
	  }
	  
	  // specular: reflection -> light
	  vec3 refl= reflection(pos, normal);
	  float specular= dot(refl, dir);
	  if (specular > 0.0)
	  {
	     float s= pow(specular, 30.0);
	     color  = vec3(0.,0.,0.0); // += s*lcol;  // BLACKED OUT specular highlighs.
	  }
      }

      return color;
}

// calculate lighting for point "pos" with "normal" and color
vec3 calcLights(vec3 pos, vec3 normal, vec3 col)
{
   vec3 color= vec3(0.0, 0.0, 0.0);    // iterate through all lights	
   color += calcLight(lightpos[0], lightcol[0], pos, normal, col);
   color += calcLight(lightpos[1], lightcol[1], pos, normal, col);	
   return color;
}

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
		
		scale*=.4; // each iteration of reflection gets darker
		 
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
   float aspect = resolution.x / resolution.y;
   vec3 p= vec3(  (gl_FragCoord.x*2.0/resolution.x-1.0)*aspect,    (gl_FragCoord.y*2.0/resolution.y-1.0),   -1.0 );
   vec3 d= normalize(p);

   sphere[0]= vec4( sin(time*.4),  cos(time*0.3),  -3.0+sin(time*0.3),  0.7);
   sphere[1]= vec4( cos(time*.3), -sin(time*.4),  -3.0+cos(time*0.3),  0.8);
   sphere[2]= vec4(-cos(time*.3),  sin(time*0.1),  -3.0-cos(time*1.0),  0.9);
   sphere[3]= vec4(-sin(time*1.3),  2. * sin(time*2.7), -4.0+cos(time*.5),  0.4);	

   colors[0]= vec3(1.0, 1.0, 1.0);
   colors[1]= vec3(0.0, 0.7, 0.6);
   colors[2]= vec3(0.3, 0.1, 1.0);
   colors[3]= vec3(0.4, 1.0, 0.0);

   lightpos[0]= vec3(-2.0, -5.0, -10.0);
   lightcol[0]= vec3(1.0, 1.0, 1.0);

//   lightpos[1]= vec3( 5.0,  -3.0, -5.0);  // orig
   lightpos[1]= vec3( -8.0,  -4.0, -8.0);  // moved lights to same src, made both white color.

//	lightcol[1]= vec3(0.6, 0.3, 1.1); // orig
   lightcol[1]= vec3(1.0, 1.0, 1.0);

	
   // trace the ray and get rgb color
   vec3 color= traceRay(p, d);

   gl_FragColor=vec4(color,1); //background color
}
