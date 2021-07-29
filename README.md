# SurfaceAnalysis
Matlab tools to estimate the area spanned by points on a triangulated surface

These tools are to estimate the (weighted) surface spanned by a set of
points on an underlying surface. That surface is given as triangulated mesh
with points in 2D or 3D.

First, the points are projected onto the surface, i.e. either to their
nearest vertices or to the nearest triangle (the latter requires remeshing
which will involve Daniel Frisch's point2trimesh function, added here for
ease). 

Instead of simply estimating the convex hull of the points, the mesh is
converted in a weighted graph, with weights given by the distances between
vertices (by default Euclidean but other distances can be used). Then, the
shortest connecting paths between all pairs of points is estimated using
Dijkstra's algorithm (implemented in Matlab: graphshortestpath). All the
resulting points of these paths are considered part of the area.
Subsequently, this shortest connecting paths search between all pairs of
the so newly defined points it iterated until the number of points no
longer increases.

The (weighted) area size can be determined via Heron's formula and the
center-of-gravity of the is determined as (weighted) mean.

Our own application is estimating cortical surfaces related to sets of
isolated TMS stimulation points - see included example - but the code is
generic and may be used for other purposes.

                                                     Andreas Daffershofer
                                                            July 29, 2021
