sources = files (
    'Container.vala',
    'IPaymentsService.vala',
    'PaymentsManager.vala',
    'PayPalService.vala',
    'Program.vala'
)

deps = [
    glib_dep,
    gobject_dep,
    gee_dep
]

executable (
    meson.project_name (),
    sources,

    dependencies: deps,
         install: true
)
