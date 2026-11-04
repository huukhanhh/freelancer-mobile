# Persistence infrastructure

Database technology and schema are not selected. Add the connection factory
and persistence adapters here after that decision. Modules access persistence
through repository boundaries. Schema changes belong in backend/migrations/.
Flutter must not import or connect to this layer.
